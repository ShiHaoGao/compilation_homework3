/************************************************************************
 *
 * @file Dataflow.h
 *
 * General dataflow framework
 *
 ***********************************************************************/

#ifndef _DATAFLOW_H_
#define _DATAFLOW_H_

#include <llvm/Support/raw_ostream.h>
#include <map>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/CFG.h>
#include <llvm/IR/Function.h>

using namespace llvm;

///Base dataflow visitor class, defines the dataflow function
// T : dfval的类型，也就是课上学的元素集合。
template<class T>
class DataflowVisitor {
public:
    virtual ~DataflowVisitor() {}

    /// Dataflow Function invoked for each basic block 
    /// 
    /// @block the Basic Block
    /// @dfval the input dataflow value
    /// @isforward true to compute dfval forward, otherwise backward
    virtual void compDFVal(BasicBlock *block, T *dfval, bool isforward) {
        if (isforward) {
            for (BasicBlock::iterator ii = block->begin(), ie = block->end(); ii != ie; ++ii) {
                Instruction *inst = &*ii;
                compDFVal(inst, dfval);
            }
        } else {
            for (BasicBlock::reverse_iterator ii = block->rbegin(), ie = block->rend(); ii != ie; ++ii) {
                Instruction *inst = &*ii;
                compDFVal(inst, dfval);
            }
        }
    }

    ///
    /// Dataflow Function invoked for each instruction
    ///
    /// @inst the Instruction
    /// @dfval the input dataflow value
    /// @return true if dfval changed
    virtual void compDFVal(Instruction *inst, T *dfval) = 0;

    ///
    /// Merge of two dfvals, dest will be ther merged result
    /// @return true if dest changed
    ///
    virtual void merge(T *dest, const T &src) = 0;
};

///
/// Dummy class to provide a typedef for the detailed result set
/// For each basicblock, we compute its input dataflow val and its output dataflow val
///
template<class T>
struct DataflowResult {
    typedef typename std::map<BasicBlock *, std::pair<T, T> > Type;
};

///
/// Compute a forward iterated fixedpoint dataflow function, using a user-supplied
/// visitor function. Note that the caller must ensure that the function is
/// in fact a monotone function, as otherwise the fixedpoint may not terminate.
///
/// @param fn The function
/// @param visitor A function to compute dataflow vals
/// @param result The results of the dataflow
/// @initval the Initial dataflow value
template<class T>
void compForwardDataflow(Function *fn,
                         DataflowVisitor<T> *visitor,
                         typename DataflowResult<T>::Type *result,
                         const T &initVal, T &entryInitVal) {

    std::set<BasicBlock *> worklist;

    // Initialize the worklist with all exit blocks
    for (auto & bi : *fn) {
        BasicBlock *bb = &bi;
        if (bb == &(fn->getEntryBlock()))
            (*result)[bb] = std::make_pair(entryInitVal, initVal);
//            result->insert(std::make_pair(bb, ));
        else
            (*result)[bb] = std::make_pair(initVal, initVal);
//            result->insert(std::make_pair(bb, std::make_pair(initVal, initVal)));
        worklist.insert(bb);
    }

    // Iteratively compute the dataflow result
    while (!worklist.empty()) {
        BasicBlock *bb = *worklist.begin();
        worklist.erase(worklist.begin());

        // Merge all incoming value to bbOutVal
        T bbInVal = (*result)[bb].first;
        for (auto si = pred_begin(bb), se = pred_end(bb); si != se; si++) {
            BasicBlock *succ = *si;
            visitor->merge(&bbInVal, (*result)[succ].second);
        }

        (*result)[bb].first = bbInVal;
        visitor->compDFVal(bb, &bbInVal, true);

        // If outgoing value changed, propagate it along the CFG
        if (bbInVal == (*result)[bb].second) continue;
        (*result)[bb].second = bbInVal;

        for (succ_iterator pi = succ_begin(bb), pe = succ_end(bb); pi != pe; pi++) {
            worklist.insert(*pi);
        }
    }
}

///
/// Compute a backward iterated fixedpoint dataflow function, using a user-supplied
/// visitor function. Note that the caller must ensure that the function is
/// in fact a monotone function, as otherwise the fixedpoint may not terminate.
/// 
/// @param fn The function
/// @param visitor A function to compute dataflow vals
/// @param result The results of the dataflow 
/// @initval The initial dataflow value
template<class T>
void compBackwardDataflow(Function *fn,
                          DataflowVisitor<T> *visitor,
                          typename DataflowResult<T>::Type *result,
                          const T &initval) {

    std::set<BasicBlock *> worklist;

    // Initialize the worklist with all exit blocks
    for (Function::iterator bi = fn->begin(); bi != fn->end(); ++bi) {
        BasicBlock *bb = &*bi;
        result->insert(std::make_pair(bb, std::make_pair(initval, initval)));
        worklist.insert(bb);
    }

    // Iteratively compute the dataflow result
    while (!worklist.empty()) {
        BasicBlock *bb = *worklist.begin();
        worklist.erase(worklist.begin());

        // Merge all incoming value to bbOutVal
        T bbOutVal = (*result)[bb].second;
        for (auto si = succ_begin(bb), se = succ_end(bb); si != se; si++) {
            BasicBlock *succ = *si;
            visitor->merge(&bbOutVal, (*result)[succ].first);
        }

        (*result)[bb].second = bbOutVal;
        visitor->compDFVal(bb, &bbOutVal, false);

        // If outgoing value changed, propagate it along the CFG
        if (bbOutVal == (*result)[bb].first) continue;
        (*result)[bb].first = bbOutVal;

        for (pred_iterator pi = pred_begin(bb), pe = pred_end(bb); pi != pe; pi++) {
            worklist.insert(*pi);
        }
    }
}

template<class T>
void printDataflowResult(raw_ostream &out,
                         const typename DataflowResult<T>::Type &dfresult) {
    for (typename DataflowResult<T>::Type::const_iterator it = dfresult.begin(); it != dfresult.end(); ++it) {
        if (it->first == NULL) out << "*";
        else it->first->dump();
        out << "\n\tin : "
            << it->second.first
            << "\n\tout :  "
            << it->second.second
            << "\n";
    }
}


#endif /* !_DATAFLOW_H_ */
