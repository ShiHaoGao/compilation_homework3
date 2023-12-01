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


struct PTAInfo {
    std::set<Instruction *> LiveVars;             /// Set of variables which are live
    PTAInfo() : LiveVars() {}

    PTAInfo(const PTAInfo &info) : LiveVars(info.LiveVars) {}

    bool operator==(const PTAInfo &info) const {
        return LiveVars == info.LiveVars;
    }
};

inline raw_ostream &operator<<(raw_ostream &out, const PTAInfo &info) {
    for (std::set<Instruction *>::iterator ii = info.LiveVars.begin(), ie = info.LiveVars.end();
         ii != ie; ++ii) {
        const Instruction *inst = *ii;
        out << inst->getName();
        out << " ";
    }
    return out;
}


class PTAVisitor : public DataflowVisitor<struct PTAInfo> {
public:
    PTAVisitor() {}

    void merge(PTAInfo *dest, const PTAInfo &src) override {
        for (std::set<Instruction *>::const_iterator ii = src.LiveVars.begin(),
                     ie = src.LiveVars.end(); ii != ie; ++ii) {
            dest->LiveVars.insert(*ii);
        }
    }

    void compDFVal(Instruction *inst, PTAInfo *dfval) override {
        if (isa<DbgInfoIntrinsic>(inst)) return;
        dfval->LiveVars.erase(inst);
        for (User::op_iterator oi = inst->op_begin(), oe = inst->op_end();
             oi != oe; ++oi) {
            Value *val = *oi;
            if (isa<Instruction>(val))
                dfval->LiveVars.insert(cast<Instruction>(val));
        }
    }
};


class PTA : public ModulePass {
public:

    static char ID;

    PTA() : ModulePass(ID) {}

//    bool runOnFunction(Function &F) override {
//        F.dump();
//        PTAVisitor visitor;
//        DataflowResult<PTAInfo>::Type result;
//        PTAInfo initval;
//
//        Info << "------------------------------\n";
//
//        compBackwardDataflow(&F, &visitor, &result, initval);
//        printDataflowResult<PTAInfo>(errs(), result);
//        return false;
//    }

    bool runOnModule(Module &M) override {
        errs() << "Hello: ";
        errs().write_escaped(M.getName()) << '\n';
        M.dump();
        errs() << "------------------------------\n";
        return false;
    }
};


#endif //PTA_H
