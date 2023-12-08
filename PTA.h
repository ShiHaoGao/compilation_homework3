//
// Created by Gao Shihao on 2023/12/1.
//

#ifndef PTA_H
#define PTA_H

//===- Hello.cpp - Example code from "Writing an LLVM Pass" ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements two versions of the LLVM "Hello World" pass described
// in docs/WritingAnLLVMPass.html
//
//===----------------------------------------------------------------------===//

#include <llvm/IR/Function.h>
#include <llvm/Pass.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/IntrinsicInst.h>

#include "Dataflow.h"
#include "utils.h"

using namespace llvm;

enum class PtrType {
    FunctionPointer, StructurePointer
};

// abstraction
//struct PointerSet {
//    PtrType ptrType;
//
//    explicit PointerSet(PtrType t) : ptrType(t) {};
//    PointerSet(const PointerSet &ps) = default;
//    virtual ~PointerSet() = 0;
//
//    PtrType getPtrType() const { return ptrType; }
//
//    void setPtrType(PtrType p) { this->ptrType = p; }
//
//    virtual void addPtr(Value *ptr) = 0;
//
//    virtual void clear() = 0;
//
//    virtual bool empty() = 0;
//
//    virtual bool operator==(const PointerSet *rhs) const = 0;
//
//};
//
//struct FuncPointerSet : PointerSet {
//    std::set<Value *> fps;
//
//    FuncPointerSet() : PointerSet(PtrType::FunctionPointer), fps{} {}
//    FuncPointerSet(const FuncPointerSet &rhs) = default;
//    ~FuncPointerSet() override = default;
//
//    void addPtr(Value* ptr) override {
//        fps.insert(ptr);
//    }
//
//    void clear() override {
//        fps.clear();
//    }
//
//    bool empty() override {
//        return fps.empty();
//    }
//
//    bool operator==(const PointerSet* rhs) const override {
//        if (auto tmp = dynamic_cast<const FuncPointerSet*>(rhs); tmp != nullptr) {
//            return fps == tmp->fps;
//        }
//        else {
//            Debug << "PointerSet dynamic cast to FuncPointerSet false!\n";
//            return false;
//        }
//    }
//
//};
//
//struct StructurePointerSet : PointerSet {
//    Value *innerPtr;
//
//    StructurePointerSet() : PointerSet(PtrType::StructurePointer), innerPtr(nullptr) {}
//    StructurePointerSet(const StructurePointerSet &rhs) = default;
//    ~StructurePointerSet() override = default;
//
//    void addPtr(Value* ptr) override {
//        innerPtr = ptr;
//    }
//
//    void clear() override {
//        innerPtr = nullptr;
//    }
//
//    bool empty() override {
//        return innerPtr == nullptr;
//    }
//
//    bool operator==(const PointerSet* rhs) const override {
//        if (auto tmp = dynamic_cast<const StructurePointerSet*>(rhs); tmp != nullptr) {
//            return innerPtr == tmp->innerPtr;
//        }
//        else {
//            Debug << "PointerSet dynamic cast to StructurePointerSet false!\n";
//            return false;
//        }
//    }
//
//};

// 指针：分两种指针
/*
struct Pointer {
    PtrType type;
    Value* val;

    Pointer(): type(PtrType::FunctionPointer), val(nullptr) {}
    explicit Pointer(PtrType t): type(t), val(nullptr) {}
    Pointer(PtrType t, Value* v): type(t), val(v) {}
    Pointer(const Pointer& p) = default;
    ~Pointer() = default;

    PtrType getPtrType() const { return type; }

    void setPtrType(PtrType p) { this->type = p; }

    bool isFuncPointer() const { return type == PtrType::FunctionPointer; }

    bool isStructPointer() const { return type == PtrType::StructurePointer; }

    bool operator==(const Pointer* rhs) const {
        return type == rhs->type && val == rhs->val;
    }

};

struct PTS {
    std::set<Pointer*> pts;

    PTS() = default;
    PTS(const PTS& pts) = default;

    void addPointer(Pointer* p) {
        pts.insert(p);
    }

    bool isExist(Pointer* p) const {
        return pts.find(p) != pts.end();
    }

    bool operator==(const PTS& rhs) const {
        if (pts.size() != rhs)
    }

};
*/


struct PTAInfo {
    std::map<Value *, std::set<Value *>> info;

    PTAInfo() : info() {}

    PTAInfo(const PTAInfo &info) = default;

    ~PTAInfo() = default;

    bool hasPointer(Value *val) const {
        return info.find(val) != info.end();
    }

    std::set<Value *> getPTS(Value *p) const {
        assert(info.find(p) != info.end());
        return info.find(p)->second;
    }

    void setPointerAndPTS(Value *val, std::set<Value *> pts) {
        info[val] = pts;
    }

    bool operator==(const PTAInfo &rhs) const {
        return info == rhs.info;
    }

};

//inline raw_ostream &operator<<(raw_ostream &out, const PTAInfo &info) {
//    out << "{ ";
//    for (const auto &item: info.pts) {
//        auto ptr = item.first;
//        auto pts = item.second;
//        out << ptr->getName() << " -> { ";
//        if (pts->getPtrType() == PtrType::FunctionPointer) {
//            for (const auto &pt: dynamic_cast<FuncPointerSet *>(pts)->fps) {
//                out << pt->getName() << ", ";
//            }
//        } else {
//            const auto &pt = dynamic_cast<StructurePointerSet *>(pts)->innerPtr;
//            out << pt->getName();
//        }
//        out << "  }, ";
//    }
//    out << "  } \n";
//    return out;
//}

inline raw_ostream &operator<<(raw_ostream &out, const PTAInfo &ptaInfo) {
    static int valNum = 0;
    out << "{ ";
    for (const auto &item: ptaInfo.info) {
        auto ptr = item.first;
        auto pts = item.second;
        std::string ptrName = ptr->getName();
        if (ptrName.empty()) {
            ++valNum;
            ptr->setName("%" + std::to_string(valNum));
            ptrName = ptr->getName();
        }
        out << ptrName << " -> { ";
        for (auto p: pts) {
            std::string pName = p->getName();
            if (pName.empty()) {
                ++valNum;
                ptr->setName("%" + std::to_string(valNum));
                pName = p->getName();
//                pName = std::to_string(p->getValueID());
            }
            out << pName << ", ";
        }
        out << "}; ";
    }
    out << "  } \n";
    return out;
}


class PTAVisitor : public DataflowVisitor<struct PTAInfo> {
public:
    explicit PTAVisitor(DataflowResult<PTAInfo>::Type* res): dfResult(res) {}

    void merge(PTAInfo *dest, const PTAInfo &src) override {

        for (const auto &it: src.info) {
            auto ptr = it.first;
            auto srcPTS = it.second;

            if (!dest->hasPointer(ptr)) {  // 如果在dest中不存在这个value
                dest->setPointerAndPTS(ptr, srcPTS);  // 创建这个value，把src中的pts copy过来。
            } else {
                auto destPTS = dest->getPTS(ptr);
                if (ptr->getType()->isFunctionTy()) {
                    destPTS.merge(srcPTS);
                    dest->setPointerAndPTS(ptr, destPTS);
                    continue;
                }

                if (ptr->getType()->getPointerElementType()->isStructTy() ||
                    ptr->getType()->getPointerElementType()->isArrayTy()) { // 如果value 是结构体指针类型
                    auto destPtr = *(destPTS.begin());
                    auto srcPtr = *(srcPTS.begin());
                    if (srcPTS.size() > 1 || destPTS.size() > 1)
                        Error << "Pts size of struct is more then one! \n";
                    else if (srcPTS.size() == 1 && destPTS.size() == 1 && destPtr != srcPtr) {
                        // 找到functionPointer type的Value
                        auto p = destPtr;
                        auto q = srcPtr;
                        while (p->getType()->getPointerElementType()->isStructTy()) {
                            if (!dest->hasPointer(p))
                                Error << "Don't have dest pointer.\n";
                            p = *(dest->getPTS(p).begin());
                        }
                        while (q->getType()->getPointerElementType()->isStructTy()) {
                            if (!dest->hasPointer(q))
                                Error << "Don't have dest pointer.\n";
                            q = *(src.getPTS(q).begin());
                        }
                        // 合并
                        auto tmpSet = dest->getPTS(p);
                        tmpSet.merge(src.getPTS(q));
                        dest->setPointerAndPTS(p, tmpSet);

                    } else {
                        std::set<Value *> mergedSet;
                        std::set_union(srcPTS.begin(), srcPTS.end(), destPTS.begin(), destPTS.end(),
                                       std::inserter(mergedSet, mergedSet.begin()));
                        dest->setPointerAndPTS(ptr, mergedSet);
                    }
                }
                else { // 非结构体指针类型
                    std::set<Value *> mergedSet;
                    std::set_union(srcPTS.begin(), srcPTS.end(), destPTS.begin(), destPTS.end(),
                                   std::inserter(mergedSet, mergedSet.begin()));
                    dest->setPointerAndPTS(ptr, mergedSet);
                }
            }

        }
    }

    void compDFVal(Instruction *inst, PTAInfo *dfVal) override {
        // 不处理调试相关的指令
        if (isa<DbgInfoIntrinsic>(inst)) return;

//        Info << "Current instruction: " << inst->getName() << '\n';

        // 根据指令的类型去进行相应的处理操作
        if (auto *allocaInst = dyn_cast<AllocaInst>(inst)) {
            // 好像用不着，嘿嘿
            evalAllocaInst(allocaInst, dfVal);
        } else if (auto *storeInst = dyn_cast<StoreInst>(inst)) {
            evalStoreInst(storeInst, dfVal);
        } else if (auto *loadInst = dyn_cast<LoadInst>(inst)) {
            evalLoadInst(loadInst, dfVal);
        } else if (auto *getElementPtrInst = dyn_cast<GetElementPtrInst>(inst)) {
            evalGetElementPtrInst(getElementPtrInst, dfVal);
        } else if (auto *memCpyInst = dyn_cast<MemCpyInst>(inst)) {
            evalMemCpyInst(memCpyInst, dfVal);
        } else if (auto *bitCastInst = dyn_cast<BitCastInst>(inst)) {
            evalBitCastInst(bitCastInst, dfVal);
        } else if (auto *memSetInst = dyn_cast<MemSetInst>(inst)) {
            // 捕获但不需要处理，防止它被后面CallInst的处理逻辑捕获
        } else if (auto *returnInst = dyn_cast<ReturnInst>(inst)) {
            evalReturnInst(returnInst, dfVal);
        } else if (auto *callInst = dyn_cast<CallInst>(inst)) {
            evalCallInst(callInst, dfVal);
        } else if (auto *phiNode = dyn_cast<PHINode>(inst) ) {
            evalPhiNode(phiNode, dfVal);
        } else {
//            Debug << "Unhandled instruction: " << inst->getName() << '\n';
        }
    }

    void printResults(raw_ostream &out) const {
        for (const auto &result: functionCallResult) {
            out << result.first << " : ";
            const auto &funcNames = result.second;
            for (auto iter = funcNames.begin(); iter != funcNames.end(); iter++) {
                if (iter != funcNames.begin()) {
                    out << ", ";
                }
                out << *iter;
            }
            out << "\n";
        }
    }

private:
    DataflowResult<PTAInfo>::Type* dfResult;
    std::map<unsigned, std::set<std::string>> functionCallResult;

    void evalStoreInst(StoreInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalStoreInst \n";
        Value *from = pInst->getValueOperand();
        Value *to = pInst->getPointerOperand();

        if (pPTAInfo->hasPointer(to)) {
            if (pPTAInfo->hasPointer(from) || isa<Function>(from))
                pPTAInfo->setPointerAndPTS(to, std::set < Value * > {from});
            else
                Error << "Don't have from. \n";
        } else {
            Error << "StoreInst don't have from pointer and to pointer in PTAInfo. \n";
        }

    }

    void evalAllocaInst(AllocaInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalAllocaInst \n";
        auto *result = dyn_cast<Value>(pInst);
        pPTAInfo->setPointerAndPTS(result, std::set < Value * > {});
    }

    void evalLoadInst(LoadInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalLoadInst \n";
        Value *pointer = pInst->getPointerOperand();
        auto *result = dyn_cast<Value>(pInst);

        // bind the %pointer's pts to %result's pts。
        if (pPTAInfo->hasPointer(pointer)) {
            auto pointerPTS = pPTAInfo->getPTS(pointer);
            pPTAInfo->setPointerAndPTS(result, pointerPTS);
        } else {
            Debug << "evalLoadInst fail! The Pointer that the loadInst loads from isn't exist in PTS! \n";
        }
    }

    void evalGetElementPtrInst(GetElementPtrInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalGetElementPtrInst \n";
        Value *structurePtr = pInst->getPointerOperand();
        auto *result = dyn_cast<Value>(pInst);

        if (!pPTAInfo->hasPointer(structurePtr))
            Debug << "The pointer in getelementptrInst haven't been in the PTAInfo. \n";

        auto ptrPTS = pPTAInfo->getPTS(structurePtr);
        if (ptrPTS.size() > 1)
            Debug << "The structure pointer's PTS has more then one pointer. \n";

        pPTAInfo->setPointerAndPTS(result, std::set < Value * > {});

        if (ptrPTS.empty() || isa<StoreInst>(pInst->getNextNode())) {  // store mode
//            ptrPTS.insert(result);
            pPTAInfo->setPointerAndPTS(structurePtr, std::set < Value * > {result});
        } else {   // load mode
            auto innerPtr = *(ptrPTS.begin());
            if (!pPTAInfo->hasPointer(innerPtr))
                Debug << "Wrong Pointer. \n";
            pPTAInfo->setPointerAndPTS(result, std::set < Value * > {innerPtr});
        }

    }

    void evalMemCpyInst(MemCpyInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalMemCpyInst \n";

        // getSource()和getDest()函数可以自动处理BitCast，提取出最终的操作数
        Value *source = pInst->getSource();
        Value *dest = pInst->getDest();
        pPTAInfo->setPointerAndPTS(dest, pPTAInfo->getPTS(source));

    }

    void evalBitCastInst(BitCastInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalBitCastInst \n";
        Value *ptr = pInst->getOperand(0);
        auto *result = dyn_cast<Value>(pInst);

        if (!pPTAInfo->hasPointer(ptr))
            Error << "Don't has pointer in BitCastInst.\n";
//        pPTAInfo->setPointerAndPTS(ptr, std::set<Value*>{result});
        pPTAInfo->setPointerAndPTS(result, std::set<Value*>{ptr});

    }

    void evalReturnInst(ReturnInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalReturnInst \n";
//        pInst->print(llvm::errs());
        Value *retValue = pInst->getReturnValue();
        auto *func = pInst->getFunction();
        if (pInst->getFunction()->getReturnType()->isVoidTy() || !retValue->getType()->isPointerTy()) {
            Info << "Return Type is not a Pointer. \n";
            return ;
        }

        if (!pPTAInfo->hasPointer(retValue))
            Error << "ReturnInst don't have retValue in PTAInfo.\n";

//        Info << "Has pointer return value. \n";
        auto pts = pPTAInfo->getPTS(retValue);
        pPTAInfo->setPointerAndPTS(func, pts);
//        pPTAInfo->setPointerAndPTS(func, std::set<Value*>{});
    }

    void evalPhiNode(PHINode *phiNode, PTAInfo *pPTAInfo) {
        Info << "evalPhiNode \n";
        auto* result = dyn_cast<Value>(phiNode);
        //
        std::set<Value*> pts;
        for (Value *val: phiNode->incoming_values()) {
            if (isa<ConstantPointerNull>(val))
                continue;
            pts.insert(val);
        }
        pPTAInfo->setPointerAndPTS(result, pts);
    }

    void evalCallInst(CallInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalCallInst \n";
        Value *funcPointer = pInst->getCalledOperand();
        unsigned lineno = pInst->getDebugLoc().getLine();
//        Error << lineno << funcPointer->getName();

        // 对malloc进行特判
        if (funcPointer->getName() == "malloc") {
            functionCallResult[lineno] = std::set<std::string>{funcPointer->getName()};
            pPTAInfo->setPointerAndPTS(dyn_cast<Value>(pInst), std::set<Value*>{});
            return;
        }

        if (functionCallResult.find(lineno) == functionCallResult.end())
            functionCallResult[lineno] = std::set<std::string>{};

        // 构建调用集合
        auto mayCallFuncSet = buildMayCallSet(funcPointer, pPTAInfo);

        // 保存调用点信息
        std::set<std::string> mayCallSet;
        for (auto* val : mayCallFuncSet) {
//            Error << val->getName() ;
            mayCallSet.insert(val->getName());
        }
        auto funcNameSet = functionCallResult[lineno];
        std::set<std::string> mergedSet;
        std::set_union(funcNameSet.begin(), funcNameSet.end(), mayCallSet.begin(), mayCallSet.end(), std::inserter(mergedSet, mergedSet.begin()));
        functionCallResult[lineno] = mergedSet;

        bool flag = false;
        PTAInfo tmp = *pPTAInfo; // 保存程序点入口状态
        std::vector<PTAInfo> retPoints;  // 保存程序点call结束状态集合
        // 进入新函数中。
        for (auto *f : mayCallFuncSet) {
            *pPTAInfo = tmp;

            if (!isa<Function>(f))
                Error << "mayCallFuncSet has wrong val that isn't a Function. \n";
            auto* func = dyn_cast<Function>(f);

            // 如果是指针类型，进行参数绑定
            for (unsigned i = 0, num = pInst->getNumArgOperands(); i < num; i++) {
                auto *callerArg = pInst->getArgOperand(i); // 取得实参。
                // 只处理指针传递就可以了，相当于load
                if (!callerArg->getType()->isPointerTy())
                    continue;
                auto *calleeArg = func->getArg(i); // 取得形参。

                // 取得实参的pts
                std::set<Value*> callerPts;
                if (pPTAInfo->hasPointer(callerArg)) {
                    callerPts = pPTAInfo->getPTS(callerArg);
                }
                else if (isa<Function>(callerArg)) {
                    callerPts.insert(callerArg);
                }
                else
                    Error << "Don't have actual Arg pointer in callInst.\n";

                // 将实参的pts绑定到形参上
                if (pPTAInfo->hasPointer(calleeArg)) { // 如果形参已经被绑定过了，只需要合并pts。
                    auto calleePts = pPTAInfo->getPTS(calleeArg);
                    calleePts.merge(callerPts);
                    pPTAInfo->setPointerAndPTS(calleeArg, calleePts);
                }
                else {  // 没有绑定过，将pts绑定上去。
                    pPTAInfo->setPointerAndPTS(calleeArg, callerPts);
                }
            }

            // 改变控制流
            PTAInfo initVal{};
            auto newPTAInfo = compForwardDataflow(func, this, dfResult, initVal, *pPTAInfo);

            *pPTAInfo = newPTAInfo;

            // 返回值绑定
            auto *callResult = dyn_cast<Value>(pInst);
            if (!func->getReturnType()->isPointerTy()) {
                Info << "Function " << func->getName() << " don't has a pointer return type. Don't need to bind retVal. \n";
            }
            else {
                Info << "Function " << func->getName() << " has a pointer return type. Need to bind retVal. \n";

                if (!newPTAInfo.hasPointer(func))
                    Error << "Don't has retValue pts\n";

                auto funcPTS = pPTAInfo->getPTS(func);
                pPTAInfo->setPointerAndPTS(callResult, funcPTS);
            }

            retPoints.push_back(*pPTAInfo);
        }

        // 合并所有返回程序点的状态。
        if (retPoints.size() == 1) {
            *pPTAInfo = retPoints[0];
            return ;
        }
        *pPTAInfo = retPoints[0];
        for (int i = 1; i < retPoints.size(); ++i) {
            merge(pPTAInfo, retPoints[i]);
        }
    }

    std::set<Value*> buildMayCallSet(Value* funcPointer, PTAInfo* pPTAInfo) {
        std::set<Value*> mayCallSet{};

        std::set<Value*> worklist;
        worklist.insert(funcPointer);
        while (!worklist.empty()) {
            auto val = *worklist.begin();
            worklist.erase(val);
            if (isa<Function>(val)) {
                mayCallSet.insert(val);
            } else if (pPTAInfo->hasPointer(val)) {
                auto pts = pPTAInfo->getPTS(val);
                for (auto *ptr: pts) {
                    worklist.insert(ptr);
                }
            } else {
                Error << "Don't have been called function Pointer in PTAInfo. \n";
            }
        }

        return mayCallSet;
    }

};


class PTA : public ModulePass {
public:

    static char ID;

    PTA() : ModulePass(ID) {}

    bool runOnModule(Module &M) override {
//        errs() << "Hello: ";
//        errs().write_escaped(M.getName()) << '\n';
        M.dump();
        errs() << "------------------------------\n";


        DataflowResult<PTAInfo>::Type result; // {basicBlock: (pts_in, pts_out)}
        PTAVisitor visitor(&result);
        PTAInfo initVal{};



        // 假设最后一个函数是程序的入口函数
        auto f = M.rbegin(), e = M.rend();
        for (; (f->isIntrinsic() || f->empty()) && f != e; f++) {
        }

        compForwardDataflow(&*f, &visitor, &result, initVal, initVal);
        printDataflowResult<PTAInfo>(errs(), result);
        visitor.printResults(errs());
        return false;
    }
};


#endif //PTA_H
