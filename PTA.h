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

    std::set<Value *> getPTS(Value *p) {
        return info[p];
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
    out << "{ ";
    for (const auto &item: ptaInfo.info) {
        auto ptr = item.first;
        auto pts = item.second;
        out << ptr->getName() << " -> { ";
        for (auto p: pts) {
            out << p->getName() << ", ";
        }
        out << "}; ";
    }
    out << "  } \n";
    return out;
}


class PTAVisitor : public DataflowVisitor<struct PTAInfo> {
public:
    PTAVisitor() {}

    void merge(PTAInfo *dest, const PTAInfo &src) override {

        for (const auto & it : src.info) {
            auto ptr = it.first;
            auto srcPTS = it.second;

            if (!dest->hasPointer(ptr)) {  // 如果在dest中不存在这个value
                dest->setPointerAndPTS(ptr, srcPTS);  // 创建这个value，把src中的pts copy过来。
            } else {
                auto destPTS = dest->getPTS(ptr);
                if (ptr->getType()->getTypeID() == Type::StructTyID) { // 如果value 是结构体类型
                    if (srcPTS.size() > 1 || destPTS.size() > 1)
                        Error << "Pts size of struct is more then one! \n";
                    else if (srcPTS.size() == 1 && destPTS.size() == 1 && *(srcPTS.begin()) != *(destPTS.begin())) {
                        StructType* myStructType = StructType::create({Type::getInt32Ty(context), Type::getFloatTy(context)}, "MyStruct");
                        Value* innerPtr = new Value(myStructType, 0);
                    } else {

                    }
                    if (*srcPTS.begin())
                }
                else {
                    std::set<Value*> mergedSet;
                    std::set_union(srcPTS.begin(), srcPTS.end(), destPTS.begin(), destPTS.end(), std::inserter(mergedSet, mergedSet.begin()));
                    dest->setPointerAndPTS(ptr, mergedSet);
                }
            }

        }
    }

    void compDFVal(Instruction *inst, PTAInfo *dfVal) override {
        // 不处理调试相关的指令
        if (isa<DbgInfoIntrinsic>(inst)) return;

        Info << "Current instruction: " << inst->getName() << '\n';

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
        } else if (auto *memSetInst = dyn_cast<MemSetInst>(inst)) {
            // 捕获但不需要处理，防止它被后面CallInst的处理逻辑捕获
        } else if (auto *returnInst = dyn_cast<ReturnInst>(inst)) {
            evalReturnInst(returnInst, dfVal);
        } else if (auto *callInst = dyn_cast<CallInst>(inst)) {
            evalCallInst(callInst, dfVal);
        } else {
//            Debug << "Unhandled instruction: " << inst->getName() << '\n';
        }
    }

private:

    void evalStoreInst(StoreInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalStoreInst \n";
        Value *from = pInst->getValueOperand();
        Value *to = pInst->getPointerOperand();

        if (pPTAInfo->hasPointer(to)) {
            if (pPTAInfo->hasPointer(from) || isa<Function>(from))
                pPTAInfo->setPointerAndPTS(to, std::set<Value*>{from});
            else
                Error << "Don't have from. \n";
        }
        else {
            Error << "StoreInst don't have from pointer and to pointer in PTAInfo. \n";
        }

    }

    void evalAllocaInst(AllocaInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalAllocaInst \n";
        auto *result = dyn_cast<Value>(pInst);
        pPTAInfo->setPointerAndPTS(result, std::set<Value*>{});
    }

    void evalLoadInst(LoadInst *pInst, PTAInfo *pPTAInfo) {
        Info << "evalLoadInst \n";
        Value *pointer = pInst->getPointerOperand();
        auto *result = dyn_cast<Value>(pInst);

        // bind the %pointer's pts to %result's pts。
        if (pPTAInfo->hasPointer(pointer)) {
            auto pointerPTS = pPTAInfo->getPTS(pointer);
            pPTAInfo->setPointerAndPTS(result, pointerPTS);
        }
        else {
            Debug << "evalLoadInst fail! The Pointer that the loadInst loads from isn't exist in PTS! \n";
        }
    }

    void evalGetElementPtrInst(GetElementPtrInst* pInst, PTAInfo * pPTAInfo) {
        Info << "evalGetElementPtrInst \n";
        Value *ptr = pInst->getPointerOperand();
        auto *result = dyn_cast<Value>(pInst);

        if (!pPTAInfo->hasPointer(ptr))
            Debug << "The pointer in getelementptrInst haven't been in the PTAInfo. \n";

        auto ptrPTS = pPTAInfo->getPTS(ptr);
        if (ptrPTS.size() > 1)
            Debug << "The structure pointer's PTS has more then one pointer. \n";

        pPTAInfo->setPointerAndPTS(result, std::set<Value*>{});

        if (ptrPTS.empty()) {  // store mode
            ptrPTS.insert(result);
            pPTAInfo->setPointerAndPTS(ptr, ptrPTS);
        }
        else {   // load mode
            auto innerPtr = *(ptrPTS.begin());
            if (!pPTAInfo->hasPointer(innerPtr))
                Debug << "Wrong Pointer. \n";
            pPTAInfo->setPointerAndPTS(result, std::set<Value*>{innerPtr});
        }

    }

    void evalMemCpyInst(MemCpyInst* pInst, PTAInfo * pPTAInfo) {
        Info << "evalMemCpyInst \n";
    }

    void evalReturnInst(ReturnInst* pInst, PTAInfo * pPTAInfo) {
        Info << "evalReturnInst \n";
    }

    void evalCallInst(CallInst* pInst, PTAInfo * pPTAInfo) {
        Info << "evalCallInst \n";
    }

};


class PTA : public ModulePass {
public:

    static char ID;

    PTA() : ModulePass(ID) {}

    bool runOnModule(Module &M) override {
        errs() << "Hello: ";
        errs().write_escaped(M.getName()) << '\n';
        M.dump();
        errs() << "------------------------------\n";

        PTAVisitor visitor;
        DataflowResult<PTAInfo>::Type result; // {basicBlock: (pts_in, pts_out)}
        PTAInfo initVal{};



        // 假设最后一个函数是程序的入口函数
        auto f = M.rbegin(), e = M.rend();
        for (; (f->isIntrinsic() || f->empty()) && f != e; f++) {
        }

        compForwardDataflow(&*f, &visitor, &result, initVal);
        printDataflowResult<PTAInfo>(errs(), result);

        return false;
    }
};


#endif //PTA_H
