#/usr/bin/python3
from abc import ABC, abstractmethod
import sys
import os
import tempfile
from argparse import ArgumentParser
from Cheetah.Template import Template
from pathlib import Path
from enum import Enum

class Expression(ABC):
    def __init__(self):
        pass

    @abstractmethod
    def generateCode(self, lang="Fortran"):
        pass

    @abstractmethod
    def getName(self):
        pass

    @abstractmethod
    def getVarsWithDuplicates(self):
        pass

    # Get sorted variables without duplications
    def getVars(self):
        vars = self.getVarsWithDuplicates()
        return sorted(set(vars))

    @abstractmethod
    def getVarTypeDict(self):
        pass

    @abstractmethod
    def getStrideVarDict(self):
        pass

    # Get operations in order
    @abstractmethod
    def getOps(self):
        pass

class Stride(Enum):
    UNIT='1'
    LDA='L'


    # for A[firstDim][]
    def firstDim(self, lang, nameSpace):
        dimDict={('C', Stride.UNIT):'${cNonStride}', ('C', Stride.LDA):'${cStride}', 
                      ('Fortran', Stride.UNIT):'${fStride}', ('Fortran', Stride.LDA):'${fNonStride}'}
        return str(Template(dimDict[(lang, self)], nameSpace))
    
    # for A[][secDim]
    def secDim(self, lang, nameSpace):
        dimDict={('C', Stride.UNIT):'${cStride}', ('C', Stride.LDA):'${cNonStride}', 
                      ('Fortran', Stride.UNIT):'${fNonStride}', ('Fortran', Stride.LDA):'${fStride}'}
        return str(Template(dimDict[(lang, self)], nameSpace))

class SimpleExpression(Expression):
    def __init__(self, stride, lhs, templateDef, ctemplateDef, varList):
        super().__init__()
        self.varList = ['lhs']+varList
        self.strideVarNameSpace = { 'cStride':'x', 'cNonStride':'y', 'fStride':'y', 'fNonStride':'x' } 
        self.nameSpace = { 'lhs': lhs }
        self.nameSpace.update(self.strideVarNameSpace)
        strideVarNameSpace = { 'cD1':stride.firstDim('C', self.nameSpace), 'cD2': stride.secDim('C', self.nameSpace), \
            'fD1': stride.firstDim('Fortran', self.nameSpace), 'fD2': stride.secDim('Fortran', self.nameSpace) }
        self.nameSpace.update(strideVarNameSpace)
        self.template = Template(templateDef, self.nameSpace)
        self.ctemplate = Template(ctemplateDef, self.nameSpace)
        self.stride = stride

    def getVar(self, v):
        return self.nameSpace[v]

    def getStrideVarDict (self):
        return self.strideVarNameSpace

    def getVarsWithDuplicates(self):
        return [self.nameSpace[v] for v in self.varList ]

    def getTemplate(self, lang='Fortran'):
        return self.template if lang=="Fortran" else self.ctemplate
    
    def generateCode(self, lang="Fortran"):
        return [str(self.getTemplate(lang))]

    # Get operations in order
    def getOps(self):
        return self.getOp()

    # Get operations in order
    @abstractmethod
    def getOp(self):
        pass

    def getNamePrefix(self):
        return self.getOp()+self.stride.value

class ExpressionList(Expression):
    def __init__(self, exps):
        super().__init__()
        self.exps = exps

    def generateCode(self, lang="Fortran"):
        return sum([e.generateCode(lang) for e in self.exps], [])

    def getName(self):
        return "".join([exp.getName() for exp in self.exps])

    def getVarsWithDuplicates(self):
        return sum([e.getVars() for e in self.exps], [])

    def getStrideVarDict(self):
        return {k:v for e in self.exps for k,v in e.getStrideVarDict().items()}

    # Get operations in order
    def getOps(self):
        return [e.getOps() for e in self.exps]

    def getVarTypeDict(self):
        return {k:v for e in self.exps for k, v in e.getVarTypeDict().items() }


class MatInitExpression(SimpleExpression):
    def __init__(self, stride, lhs):
       super().__init__(stride, lhs, '${lhs}(${fD1},${fD2}) = 0', '${lhs}[${cD1}][${cD2}] = 0;', []) 

    def getName(self):
        return self.getNamePrefix()+self.getVar('lhs')

    # Get operations in order
    def getOp(self):
        return "I"

    def getVarTypeDict(self):
        return {self.getVar('lhs'):'A'}

class MatScaleExpression(SimpleExpression):
    def __init__(self, stride, lhs, rhs):
       super().__init__(stride, lhs, 
                        '${lhs}(${fD1},${fD2}) = ${rhs}(${fD1},${fD2}) * g', 
                        '${lhs}[${cD1}][${cD2}] = ${rhs}[${cD1}][${cD2}] * g;', ['rhs']) 
       self.nameSpace['rhs'] = rhs

    def getName(self):
        return self.getNamePrefix()+self.getVar('lhs')+self.getVar('rhs')

    # Get operations in order
    def getOp(self):
        return "S"

    def getVarTypeDict(self):
        return {self.getVar('lhs'):'A', self.getVar('rhs'):'A' }

class MatAddExpression(SimpleExpression):
    def __init__(self, stride, lhs, rhs1, rhs2):
       super().__init__(stride, lhs, 
                        '${lhs}(${fD1},${fD2}) = ${rhs1}(${fD1},${fD2}) + ${rhs2}(${fD1},${fD2})', 
                        '${lhs}[${cD1}][${cD2}] = ${rhs1}[${cD1}][${cD2}] + ${rhs2}[${cD1}][${cD2}];', ['rhs1', 'rhs2']) 
       self.nameSpace['rhs1'] = rhs1
       self.nameSpace['rhs2'] = rhs2

    def getName(self):
        return self.getNamePrefix()+self.getVar('lhs')+self.getVar('rhs1')+self.getVar('rhs2')

    # Get operations in order
    def getOp(self):
        return "A"

    def getVarTypeDict(self):
        return {self.getVar('lhs'):'A', self.getVar('rhs1'):'A', self.getVar('rhs2'): 'A' }

class MatMulExpression(SimpleExpression):
    def __init__(self, stride, lhs, rhs1, rhs2):
       super().__init__(stride, lhs, 
                        '${lhs}(${fD1},${fD2}) = ${lhs}(${fD1},${fD2}) + ${rhs1}(${fD1},k)*${rhs2}(k,${fD2})', 
                        '${lhs}[${cD1}][${cD2}] = ${lhs}[${cD1}][${cD2}] + ${rhs1}[${cD1}][k]*${rhs2}[k][${cD2}];', ['rhs1', 'rhs2']) 
       self.nameSpace['rhs1'] = rhs1
       self.nameSpace['rhs2'] = rhs2

    def getName(self):
        return self.getNamePrefix()+self.getVar('lhs')+self.getVar('rhs1')+self.getVar('rhs2')

    # Get operations in order
    def getOp(self):
        return "M"

    def generateCode(self, lang='Fortran'):
        template = self.getTemplate(lang)
        if lang == 'Fortran':
            return [ 'do k = 1, n', '  '+str(template), 'end do' ]
        else:
            return [ 'for(k = 0; k < n; k++) {', '  '+str(template), '}' ]

    def getVarTypeDict(self):
        return {self.getVar('lhs'):'A', self.getVar('rhs1'):'A', self.getVar('rhs2'): 'A' }
        
        
class MatVecExpression(SimpleExpression):
    def __init__(self, stride, lhs, A_rhs, v_rhs):
       super().__init__(stride, lhs, 
                        '${lhs}(${fD1}) = ${lhs}(${fD1}) + ${A_rhs}(${fD1},${fD2})*${v_rhs}(${fD2})', 
                        '${lhs}[${cD1}] = ${lhs}[${cD1}] + ${A_rhs}[${cD1}][${cD2}]*${v_rhs}[${cD2}];', ['A_rhs', 'v_rhs']) 
       self.nameSpace['A_rhs'] = A_rhs
       self.nameSpace['v_rhs'] = v_rhs

    def getName(self):
        return self.getNamePrefix()+self.getVar('lhs')+self.getVar('A_rhs')+self.getVar('v_rhs')

    # Get operations in order
    def getOp(self):
        return "V"

    def getVarTypeDict(self):
        return {self.getVar('lhs'):'v', self.getVar('A_rhs'): 'A', self.getVar('v_rhs'):'v' }

def generateCode(exp, root, outpath, lang='Fortran'):
    ops = exp.getOps()
    vars = exp.getVars()
    batch="{:02d}_Ops_{:02d}_Arrays".format(len(ops), len(vars))
    code=exp.getName()+('.f' if lang == 'Fortran' else '.c')
    codelet=code+"_de"
    codelet_path=os.path.join(outpath, batch, code, codelet)
    print(f"Output:{codelet_path}")
    Path(codelet_path).mkdir(parents=True, exist_ok=True)
    templateDir=os.path.join(root, 'templates', lang)
    names = { 'batch': batch, 'code': code, 'codelet': codelet, 
             'vars': vars, 'stmts': exp.generateCode(lang), 'vartypes': exp.getVarTypeDict()}
    # Add the striding var dictionary        
    names.update(exp.getStrideVarDict())

    for curFile in os.listdir(templateDir):
        templateFile=os.path.join(templateDir, curFile)
        templateDef = Template(file=templateFile, searchList=[names])
        outfile = os.path.join(codelet_path, curFile)
        print(templateDef, file=open(outfile, 'w'))

def main(argv):
    parser = ArgumentParser(description='Generate Linear Algebra Codelets.')
    allexps0 = [[ 
        MatInitExpression(stride, 'a'),
        MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'a', 'b'),
        MatAddExpression(stride, 'a', 'a', 'a'), MatAddExpression(stride, 'a', 'b', 'a'),
        MatAddExpression(stride, 'a', 'b', 'b'), MatAddExpression(stride, 'a', 'b', 'c'),
        MatMulExpression(stride, 'a', 'a', 'a'), 
        MatMulExpression(stride, 'a', 'b', 'a'), MatMulExpression(stride, 'a', 'a', 'b'),
        MatMulExpression(stride, 'a', 'b', 'b'), MatMulExpression(stride, 'a', 'b', 'c'),
        MatVecExpression(stride, 'a', 'b', 'a'), MatVecExpression(stride, 'a', 'b', 'c')] 
        for stride in [Stride.LDA, Stride.UNIT]]
    allexps0 = [[ 
        MatInitExpression(stride, 'a'),
        ExpressionList([ MatInitExpression(stride, 'a'), MatScaleExpression(stride, 'a', 'a') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatScaleExpression(stride, 'a', 'b') ]),
        ExpressionList([ MatInitExpression(stride, 'a'), MatAddExpression(stride, 'a', 'a', 'a') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatAddExpression(stride, 'a', 'b', 'a') ]),
        ExpressionList([ MatInitExpression(stride, 'a'), MatAddExpression(stride, 'a', 'b', 'b') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatAddExpression(stride, 'a', 'b', 'c') ]),
        ExpressionList([ MatInitExpression(stride, 'a'), MatMulExpression(stride, 'a', 'a', 'a') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatMulExpression(stride, 'a', 'b', 'a') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatMulExpression(stride, 'a', 'a', 'b') ]),
        ExpressionList([ MatInitExpression(stride, 'a'), MatMulExpression(stride, 'a', 'b', 'b') ]), 
        ExpressionList([ MatInitExpression(stride, 'a'), MatMulExpression(stride, 'a', 'b', 'c') ]) ] 
        for stride in [Stride.LDA, Stride.UNIT]]
    allexps0 = [[ 
        # a=as X2
        ExpressionList([ MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'a', 'a') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'b', 'b') ]),
        # a=as + a=bs
        ExpressionList([ MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'a', 'b') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'b', 'a') ]),
        ExpressionList([ MatScaleExpression(stride, 'a', 'a'), MatScaleExpression(stride, 'c', 'b') ]), 
        # a=bs + a=as
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'a', 'a') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'b', 'b') ]),
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'c', 'c') ]), 
        # a=bs + a=bs
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'a', 'b') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'b', 'a') ]),
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'a', 'c') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'c', 'a') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'c', 'b') ]), 
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'b', 'c') ]),
        ExpressionList([ MatScaleExpression(stride, 'a', 'b'), MatScaleExpression(stride, 'c', 'd') ])
        ] 
        for stride in [Stride.LDA, Stride.UNIT]]


    allexps = sum(allexps0, [])

    root = os.path.dirname(__file__)
    srcdirname=os.path.join(root, 'src')
    print('dirname', srcdirname)
    fSrc=os.path.join(srcdirname, 'Fortran')
    cSrc=os.path.join(srcdirname, 'C')
    Path(fSrc).mkdir(parents=True, exist_ok=True)
    Path(cSrc).mkdir(parents=True, exist_ok=True)
    for exp in allexps:
        generateCode (exp, root, fSrc, lang="Fortran")
        generateCode (exp, root, cSrc, lang="C")

    print('Done')

if __name__ == "__main__":
    main(sys.argv[1:])
