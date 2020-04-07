
function [verbose,verboseI,debug,doPlot,maxFunEvals,maxIter,tolFun,tolX,method,...
    corrections,c1,c2,LS_init,LS,cgSolve,qnUpdate,cgUpdate,initialHessType,...
    HessianModify,Fref,useComplex,numDiff,LS_saveHessianComp,...
    DerivativeCheck,Damped,HvFunc,bbType,cycle,...
    HessianIter,outputFcn,useMex,useNegCurv,precFunc] = ...
    minFunc_processInputOptions(o)

% Constants
SD = 0;
CSD = 1;
BB = 2;
CG = 3;
PCG = 4;
LBFGS = 5;
QNEWTON = 6;
NEWTON0 = 7;
NEWTON = 8;
TENSOR = 9;

verbose = 1;
verboseI= 1;
debug = 0;
doPlot = 0;
method = LBFGS;
cgSolve = 0;

o = toUpper(o);

if isfield(o,'DISPLAY')
    switch(upper(o.DISPLAY))
        case 0
            verbose = 0;
            verboseI = 0;
        case 'FINAL'
            verboseI = 0;
        case 'OFF'
            verbose = 0;
            verboseI = 0;
        case 'NONE'
            verbose = 0;
            verboseI = 0;
        case 'FULL'
            debug = 1;
        case 'EXCESSIVE'
            debug = 1;
            doPlot = 1;
    end
end


LS_init = 0;
c2 = 0.9;
LS = 4;
Fref = 1;
Damped = 0;
HessianIter = 1;
if isfield(o,'METHOD')
    m = upper(o.METHOD);
    switch(m)
        case 'TENSOR'
            method = TENSOR;
        case 'NEWTON'
            method = NEWTON;
        case 'MNEWTON'
            method = NEWTON;
            HessianIter = 5;
        case 'PNEWTON0'
            method = NEWTON0;
            cgSolve = 1;
        case 'NEWTON0'
            method = NEWTON0;
        case 'QNEWTON'
            method = QNEWTON;
            Damped = 1;
        case 'LBFGS'
            method = LBFGS;
        case 'BB'
            method = BB;
            LS = 2;
            Fref = 20;
        case 'PCG'
            method = PCG;
            c2 = 0.2;
            LS_init = 2;
        case 'SCG'
            method = CG;
            c2 = 0.2;
            LS_init = 4;
        case 'CG'
            method = CG;
            c2 = 0.2;
            LS_init = 2;
        case 'CSD'
            method = CSD;
            c2 = 0.2;
            Fref = 10;
            LS_init = 2;
        case 'SD'
            method = SD;
            LS_init = 2;
    end
end

maxFunEvals = getOpt(o,'MAXFUNEVALS',1000);
maxIter = getOpt(o,'MAXITER',500);
tolFun = getOpt(o,'TOLFUN',1e-5);
tolX = getOpt(o,'TOLX',1e-9);
corrections = getOpt(o,'CORR',100);
c1 = getOpt(o,'C1',1e-4);
c2 = getOpt(o,'C2',c2);
LS_init = getOpt(o,'LS_INIT',LS_init);
LS = getOpt(o,'LS',LS);
cgSolve = getOpt(o,'CGSOLVE',cgSolve);
qnUpdate = getOpt(o,'QNUPDATE',3);
cgUpdate = getOpt(o,'CGUPDATE',2);
initialHessType = getOpt(o,'INITIALHESSTYPE',1);
HessianModify = getOpt(o,'HESSIANMODIFY',0);
Fref = getOpt(o,'FREF',Fref);
useComplex = getOpt(o,'USECOMPLEX',0);
numDiff = getOpt(o,'NUMDIFF',0);
LS_saveHessianComp = getOpt(o,'LS_SAVEHESSIANCOMP',1);
DerivativeCheck = getOpt(o,'DERIVATIVECHECK',0);
Damped = getOpt(o,'DAMPED',Damped);
HvFunc = getOpt(o,'HVFUNC',[]);
bbType = getOpt(o,'BBTYPE',0);
cycle = getOpt(o,'CYCLE',3);
HessianIter = getOpt(o,'HESSIANITER',HessianIter);
outputFcn = getOpt(o,'OUTPUTFCN',[]);
useMex = getOpt(o,'USEMEX',1);
useNegCurv = getOpt(o,'USENEGCURV',1);
precFunc = getOpt(o,'PRECFUNC',[]);
end

function [v] = getOpt(options,opt,default)
if isfield(options,opt)
    if ~isempty(getfield(options,opt))
        v = getfield(options,opt);
    else
        v = default;
    end
else
    v = default;
end
end

function [o] = toUpper(o)
if ~isempty(o)
    fn = fieldnames(o);
    for i = 1:length(fn)
        o = setfield(o,upper(fn{i}),getfield(o,fn{i}));
    end
end
end