unit Changes30;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  Fmx.StdCtrls,
  FMX.Header, Basic3, FMX.Types, FMX.Controls, FMX.Layouts, FMX.Memo,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo.Types;


type
  TfrmChanges30 = class(TBasicForm3)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChanges30: TfrmChanges30;

implementation

{$R *.FMX}

procedure TfrmChanges30.FormCreate(Sender: TObject);
begin
  inherited;

  With RichEdit1.Lines, RichEdit1 do
  begin
    Add('   List of new features in v6.3.8 (September 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Support for Rad Studio 13');
    Add('   *   This release again refreshes the Linux support. ');
    Add('   *   Bug fix for Bessel special functions, when Nu was 0.');
    Add('   *   Added TMtx.AddDiag method. This complementes the TMtx.MulDiagLeft and TMtx.MulDiagRight for operations ' +
               'with diagonal matrices. Similar for MtxExpr.AddDiag and Matrix.AddDiag');
    Add('');
    Add('   Linux:');
    Add('   *   Intel IPP was not dispatching for all supported instruction sets. This fix delivers a big performance boost.');
    Add('   *   Reduced GCLIB requirements to 2.14 and built on RHEL 8.9.');
    Add('   *   Updated Intel One API to v2025.2');
    Add('');
    Add('   Debugger visualizer:');
    Add('   *   Added ability to copy string lists  and subranges of the string list to clipboard');
    Add('');

    Add('   List of new features in v6.3.7 (August 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Separated threading library (MtxForLoop.pas) from dependancy upon MtxVec. Moved MtxVec dependant functions to MtxVec unit. This allows the use of the threading library also in units which do not depend upon MtxVec (MtxVec Core, Lapack, Blas, etc...).');
    Add('');
    Add('   Debugger visualizer:');
    Add('   *   Debugger Tooltip visualizer launch button sometimes caused a lock-up, because it triggered multiple button press events.');
    Add('   *   Improved the automatic naming of debugger mapped variables for cases, where chars like [,] and dot were in the expression.');
    Add('   *   Significantly improved automatic column sizing for TMtxVecGrid, which is also used by the debugger visualizer.');
    Add('');
    Add('   Sparse matrices:');
    Add('   *   Moved the function to obtain OS Temp folder in to the initialization section of the sparse.pas unit and cached the result.');
    Add('');

    Add('   List of new features in v6.3.6 (June 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Added ColumnWidth parameter to TVec/TMtx/TVecInt/TMtxInt method ValuesToStrings. Useful for fixed font width text table formatting.');
    Add('   *   Matching API for the .NET Core release due to be released soon.');
    Add('   *   Renamed TMtx.Mul overload for arrays of TMtx type to TMtx.MulArray to avoid a compiler bug.');
    Add('');
    Add('   Special functions:');
    Add('   *   Bug fix for Bessel J function from SpecialFuncs.pas unit. Introduced due to upgraded compiler.');
    Add('   *   Expanded Bessel functions with computations on array with integer step between consecutive elements.');
    Add('');
    Add('   Polynoms:');
    Add('   *   Bug fix for Spline1D, which did not work correctly for X other than 0,1,2,3..');
    Add('   *   Bug fix for TPiecePoly.Evaluate(X, Y), which did not work for scalar overload, if vectorized overload was not called before.');
    Add('');

    Add('   List of new features in v6.3.5 (April 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Updated installers to install packages and search paths also for the Modern C++ Compiler and for the 64bit IDE preview.');
    Add('   *   Bug fix for MtxExpr.h which resulted in the calling of ud2 instruction for Modern C++ compiler of the C++Builder.');
    Add('   *   Bug fix for TMtx.MulElem(a: TMtxVec), which was calling the wrong overload.');
    Add('   *   Bug fix for FmxMtxVecTee.pas, for TeeChart standard (undefined variable DoubleResolution).');
    Add('   *   Catastrophic cancellation mitigation for numerical GradHess routine for cases, where gradient is near zero. The routine is used by the Optimization methods.');
    Add('   *   Ability to assign array of strings to StringList: a := [''Item1'', ''Item2'', ''Item3''], rather than calling Add method for each.');
    Add('   *   Added TVec.Mask overload.');
    Add('   *   Added Implicit conversion from array of TCplx to Vector and Matrix: aVector := [Cplx(1,2), Cplx(2,3)];');
    Add('   *   Added support for saving and loading the header row to the TVec/TMtx Caption property when saving/loading .csv files with LoadFromFile/SaveToFile method.');
    Add('');
    Add('   Probabilities:');
    Add('   *   Added three new NormalPDF, NormalCDF, NormalCDFTwoTail vectorized overloads to probabilities.pas.');
    Add('   *   Faster vectorized TriangularCDF, TriangularCDFInv, TriangularPDF.');
    Add('   *   Faster vectorized InverseGaussianPDF and InverseGaussianCDF.');
    Add('');

    Add('   List of new features in v6.3.4 (March 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Support for RAD Studio 12.3.');
    Add('   *   Added compound expressions for saturated integer math for Integer (32bit), SmallInt (16bit) and byte precision (8bit). This feature adds over 160 new overloads to TVecInt and TMtxInt (VectorInt and MatrixInt).');
    Add('   *   Added compound expressions for complex number math.');
    Add('   *   Added Exponential Integral functions E1, Ei and ExpEi to the SpecialFuncs.pas unit. By passing Log(x) as argument, this will also compute Logarithmic integrals.');
    Add('');
    Add('   Added some behaviour typically expected to exist by AI large language models:');
    Add('   *   Added ToString and Parse methods to TVec/TVecInt/TMtx/TMtxInt/Vector/VectorInt/Matrix/MatrixInt.');
    Add('   *   Added implicit conversions from TCplxArray to Vector and Matrix: aVec := [Cplx(1), Cplx(2)];');
    Add('   *   Added implicit conversions of Vector/VectorInt/Matrix/MatrixInt to TObject. The types dereference their internal data object, which is of type TVec/TVecInt/TMtx/TMtxInt.');
    Add('');

    Add('   List of new features in v6.3.3 (February 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   Added TMtx.MulSmallInit and TMtx.MulSmall methods to surface the jitted small-matrix multiply.');
    Add('   *   Small-matrix multiply features are implemented in MtxVec.TSmallMatrixMultiply class. Performance improvement ranges from 100x at matrix size 2x2 and is still 1.3x at matrix size 50x50.');
    Add('   *   Added several matrix-multiply kernels with unrolled for-loops written in pascal in MtxVecBase unit: sgemm2, dgemm2, cgemm2, zgemm2 for matrices 2x2 and variants up to size 4x4.');
    Add('   *   Added two additional compound expression functions to TVec/TMtx/Vector/Matrix: SqrAddScaled, AddScaledSqr.');
    Add('   *   Inlined the implicit conversions of Vector and Matrix types to TMtx, TVec, etc... for Rad Studio 12 and newer. This positively affects performance of Vector and Matrix types in general.');
    Add('   *   Added support for "Modern" C++ Compiler platform target in C++Builder for Rad Studio v12.2.');
    Add('   *   Added MtxVec.Controller.BlasThreadCount and adjusted the mapping of thread count for individual library sub-systems.');
    Add('   *   Fixed TCplx and TSCplx inline visualizers for Delphi Win64 debugger, when displaying NAN and INF values. Occurrence of NAN triggered an exception in the IDE, because Win64 debugger does not correctly display NAN and INF values since XE2.');
    Add('   *   Fix for complex Math387.ArcSin, when the argument was 0. This affected (complex number) Math387.ArcCos, Math387.ArcSinh, Math387.ArcCosh, Math387.ArcCsc and Math387.ArcCsch, Math387.ArcSec and Math387.ArcSech, which all call this function.');
    Add('');

    Add('   List of new features in v6.3.1 (January 2025):');
    Add('');
    Add('   Core product:');
    Add('   *   New set of "compound" expression functions added to TVec/TMtx/Vector/Matrix to speed up computation of basic +/-* math. A total of 162 new overloads have been added to Vector and the same amount to the Matrix type.');
    Add('   *   Added extended CPU info (thread, core and instruction support) used by MtxVec.Controller that works across Intel and AMD CPUs. Check the Intro page of this demo for an example how to access and display this information.');
    Add('   *   Fixed MtxVec.Controller.CPUCores to work correctly also for AMD CPUs.');
    Add('   *   Added a dedicated set of performance DLLs targeting AMD Zen architecture for AVX2 and AVX512 instruction set. Although not comprehensive they do improve some algorithms considerably and are a first step towards more comprehensive support also for AMD. These libraries are a separate download for registered customers.');
    Add('');
    Add('   Sparse matrices:');
    Add('   *   Added TSparseMtx.SvdSymLargest, find user specified number of largest SVD values of sparse symmetric matrices.');
    Add('   *   Added TSparseMtx.SvdSymSmallest, find user specified number of smallest SVD values of sparse symmetric matrices.');
    Add('   *   Added TSparseMtx.EigSymLargest, TSparseMtx.EigSymGenLargest for user specified number of largest (generalized) eigen-values of sparse symmetric matrices.');
    Add('   *   Added TSparseMtx.EigSymSmallest, TSparseMtx.EigSymGenSmallest for user specified number of largest (generalized) eigen-values of sparse symmetric matrices.');
    Add('   *   Optionally, TSparseMtx.TripletsToSparse can either use or drop zeros on the main diagonal.');
    Add('');

    Add('   List of new features in v6.3.0 (December 2024):');
    Add('');
    Add('   Core product:');
    Add('   *   Updated for Intel OneAPI v2025.0. Since the end of 2023 only the 64bit libraries continue receiving updates from Intel. New version of libiomp5md.dll is required. There will be an error about missing procedure entry point __kmpc_masked, if not provided. Make sure that the new version DLL overwrites the old one.');
    Add('   *   Added SqrAbs combined function to Math387 for complex number TCplx and TSCplx types.');
    Add('   *   Added Exp2Int to Math387 for integer based exponentials (up to 32bit range).');
    Add('   *   Added Exp2Int64 to Math387 for integer based exponentials (up to 64bit range).');
    Add('   *   Added Log2Int to Math387 for integer based exponentials (up to 32bit range).');
    Add('   *   Added Log2Int64 to Math387 for integer based exponentials (up to 64bit range).');
    Add('   *   Bug fix for TMtxGridSeries (VCL), where the Src parameter is single precision.');
    Add('   *   Both Lapack and FFT threading are now disabled globally and become enabled only on user''s request. There were too many cases of performance degradation when threading was enabled too soon for too short data.');
    Add('   *   Added implicit conversions to PDouble, PSingle, PCplx, PSCplx to Vector and Matrix.');
    Add('   *   Added implicit conversions to PInteger, PSmallInt and PByte for VectorInt and MatrixInt.');
    Add('');
    Add('   Debugger Visualizer v2:');
    Add('   *   Bug fix for IDE''s Run->View Value and Run->Draw Values. The shortcut was working, but menu command not.');
    Add('   *   Changed IDE menu command shortcut for View Values to CTRL+SHIFT+F6 from CTRL+F6.');
    Add('   *   Added ability to add both "View Values..." and "Draw Values..." commands to IDE Toolbar.');
    Add('   *   Added Visualizer optimization preventing evaluation of vars, when no visualizer windows are open.');
    Add('   *   Visualizer docking window bug fixed.');
    Add('   *   Visualizer bug fix for single precision, byte and shortInt vectors and matrices.');
    Add('   *   Visualizer dead-lock fix, if an exception happened in background evaluation.');
    Add('   *   Bug fix for Inline Visualizer improving stability.');
    Add('   *   Bug fix for Single precision Form visualizer when charting with xAxis parameter.');
    Add('   *   Upgraded FMX variant of TMtxGridSeries to match implementation of the VCL version.');
    Add('');

    Add('   Technical note for MtxVec v6.2.5 affecting Debugger Visualizer (September 2024):');
    Add('');
    Add('   *   MtxVec packages may not be installed with range-checking enabled. The build tool will respect this. An immediate crash is possible otherwise.');
    Add('   *   The use of "IDE Fix pack" packages is not recommended. An immediate crash is possible.');
    Add('   *   Your own project needs to be compiled with "use debug dcu''s" option checked for the compiler to support all features.');
    Add('');

    Add('   Changes for MtxVec v6.2.5 (August 2024):');
    Add('');
    Add('   *   Bug fix TMtxGrid object, which had performance problems for column heavy matrices.');
    Add('   *   Bug fix for TVec.ValuesToStrings, which had a bug for its sub-vector indexed overload.');
    Add('   *   Bug fix for assigning TStringList objects within script.');
    Add('   *   Bug fix for debugger visualizer, which had its command line print output disabled (due to performance issues).');
    Add('   *   Important: When passing TStrings descendants to MtxVec routines like ValuesToStrings or to the Optimization routines accepting "Verbose" parameter, it should be avoided to pass TRichEdit.Lines or TMemo.Lines directly. Use an intermediate object like TStringList instead. There is a substantial performance penalty otherwise.');
    Add('');

    Add('   Changes for MtxVec v6.2.4 (July 2024):');
    Add('');
    Add('   *   First release of Dew Debugger Visualizer v2.0. This is the first major overhaul of the debugger visualizer since its first release in 2009. Stay tuned for a series of video clips to learn about the new features.');
    Add('');
    Add('   Scripting:');
    Add('   *   Added TStringList type support to TMtxExpression script. You can now call: list(i), list(2:3), or assign with list(i) = "2" or concatenate lists with [list(2:3); list(14:15)].');
    Add('   *   Added support to define externally owned TValueRec object as a variable in TMtxExpression script.');
    Add('');

    Add('   Changes for MtxVec v6.2.3 (May 2024):');
    Add('');
    Add('   *   New release of shared libs (*.so) for Linux based on latest Intel OneAPI 2024.1 and targeting GLIBC v2.27 or newer. This covers also RHEL v8.X and v9.X.');
    Add('   *   Added support for .csv and .txt file formats to TVec/TMtx/TVecInt/TMtxInt types LoadFromFile and SaveToFile methods. If the extensions are not .csv or .txt, all other extensions result in binary storage.');
    Add('   *   Fixed bug for Spline1D interpolation.');
    Add('   *   A number of performance improvements for spline based interpolation and equidistant interpolation.');
    Add('   *   Substantially improved parity of TMtxGridSeries for FireMonkey with its VCL variant.');
    Add('');

    Add('   New features for .NET and .NET Core release v6.2.2 (May 2024):');
    Add('');
    Add('   Core product:');
    Add('   *   Updated for Intel MKL and Intel IPP to OneAPI v2023.2.');
    Add('   *   Added TVecInt.Concat.');
    Add('   *   MinRows, MinCols, MaxMinRows, MaxMinCols to VectorInt / MatrixInt, Vector / Matrix.');
    Add('   *   MinEvery, MaxEvery to both VectorInt / MatrixInt, Vector / Matrix.');
    Add('   *   TMtx.ScaleRows, TMtx.ScaleCols.');
    Add('   *   Math387.TFifoCriticalSection. A fair critical section implementation. All threads enter in FIFO order.');
    Add('   *   Math387.TFairSemaphoreSection. A fair critical section that allows at most N concurrent threads.');
    Add('   *   Updated online and offline documentation.');
    Add('');
    Add('   Speed:');
    Add('   *   Much faster implementation of TMtx.TensorProd(const Vec1, Vec2: TVec).');
    Add('   *   Much faster TVec.Sqrt. Complex vectorized Sqrt sped up by roughly 10x compared to Intel VML.');
    Add('   *   Introduces first use of a fair critical section for MtxVec object cache and FFT descriptor cache.');
    Add('   *   First release to be compiled with latest Intel OneAPI DPC++ and Fortran compilers.');
    Add('   *   Updated FFT descriptors and FFT storage format for the new Intel MKL API. Only CCS storage is now available. The layout of 2D FFT from/to "real" results has changed.');
    Add('   *   Important: Only 64bit libraries are expected to receive performance improvements in the future!');
    Add('');
    Add('   Bugs fixed:');
    Add('   *   Vectorized IntPower function.');
    Add('   *   TMtx.BandedToDense function.');
    Add('   *   Object cache was missing critical section, when not using super-conductive code path.');
    Add('   *   Polynoms.IIRFilter fix for missing init of DelayLine, when not provided by user. Parameter was introduced with recent ARIMA updates.');
    Add('   *   Polynoms.DeConv fixed because of dependency upon Polynoms.IIRFilter.');
    Add('   *   TMtxVec.NormL2 fixed for complex, single precision and "core" variant.');
    Add('   *   Implemented lockless (never enters sleep(..)) TMtxVecController.MarkThread and TMtxVecController.UnMarkThread. The performance gain grows with thread count. This speeds up the threading library when calling DoForLoop method.');
    Add('   *   Object cache is now using TLS region (Thread Local Storage), to store its memory pool index. This progressively speeds up object allocation, when using more than 16 threads with the TMtxForLoop threading library.');
    Add('   *   Added BlockGranularity addressing threading with high turbo clock frequencies and Intel Alder Lake with P + E cores (asymmetric multi-processing).');
    Add('   *   Optimized critical-sections used for thread synchronisation for high thread count.');
    Add('   *   The memory cache of TVecInt and TMtxInt was not active and this caused performance degradation in the case of threading.');
    Add('');

    Add('   List of new features in v6.2.0 (November 2023):');
    Add('');
    Add('   Core product:');
    Add('   *   Updated Intel MKL and Intel IPP to OneAPI v2023.2.');
    Add('   *   Added support for RAD Studio Athens 12.0 release.');
    Add('   *   Added TVecInt.Concat.');
    Add('   *   Added MinRows, MinCols, MaxMinRows, MaxMinCols to VectorInt/MatrixInt, Vector/Matrix.');
    Add('   *   Added MinEvery, MaxEvery to both VectorInt/MatrixInt, Vector/Matrix.');
    Add('   *   Added TMtx.ScaleRows, TMtx.ScaleCols.');
    Add('   *   Added Math387.TFifoCriticalSection. A fair critical section implementation. All threads enter in FIFO order.');
    Add('   *   Added Math387.TFairSemaphoreSection. A fair critical section that allows at most N concurrent threads.');
    Add('   *   Upgraded FMX variant of TMtxGridSeries to match implementation of the VCL version.');
    Add('');
    Add('   Speed:');
    Add('   *   Much faster implementation of TMtx.TensorProd(const Vec1, Vec2: TVec).');
    Add('   *   Much faster TVec.Sqrt. Complex vectorized Sqrt sped up by roughly 10x compared to Intel VML.');
    Add('');
    Add('   Bugs fixed:');
    Add('   *   Fixed bug for IntPower function.');
    Add('   *   Fixed bug for TMtx.BandedToDense function.');
    Add('   *   Fixed bug for Move function Len parameter not typecasted to Int64. Product wide fix.');
    Add('');

    Add('   List of new features in v6.1.1:');
    Add('');
    Add('   Core product:');
    Add('   *   Introduces first use of a fair critical section for MtxVec object cache and FFT descriptor cache.');
    Add('   *   First release to be compiled with latest Intel OneAPI DPC++ and Fortran compilers.');
    Add('   *   Updated to latest Intel MKL and IPP libraries. Important: Only 64bit libraries are expected to receive performance improvements in the future!');
    Add('   *   Updated FFT descriptors and FFT storage format for the new Intel MKL API. Only CCS storage is now available. The layout of 2D FFT from/to "real" results has changed.');
    Add('   *   Bug fix. Object cache was missing critical section, when not using super-conductive code path.');
    Add('   *   Bug fix. Polynoms.IIRFilter fix for missing init of DelayLine, when not provided by user. Parameter was introduced with recent ARIMA updates.');
    Add('   *   Bug fix. Polynoms.DeConv fixed because of dependency upon Polynoms.IIRFilter.');
    Add('   *   Bug fix. TMtxVec.NormL2 fixed for complex, single precision and "core" variant.');
    Add('   *   Bug fix for single threaded overload of MtxForLoop.ClusteredKNN.');
    Add('');

    Add('   List of new features in v6.1.0:');
    Add('');
    Add('   Core product:');
    Add('   *   Implemented lockless (never enters sleep(..)) TMtxVecController.MarkThread and TMtxVecController.UnMarkThread. The performance gain grows with thread count. This speeds up the threading library when calling DoForLoop method.');
    Add('   *   Object cache is now using TLS region (Thread Local Storage), to store its memory pool index. This progressively speeds up object allocation, when using more than 16 threads with the TMtxForLoop threading library.');
    Add('   *   Added BlockGranularity addressing threading with high turbo clock frequencies and Intel Alder Lake with P+E cores (asymmetric multi-processing).');
    Add('   *   Optimized critical-sections used for thread synchronisation for high thread count.');
    Add('   *   Android 11 tagged pointer support.');
    Add('   *   Updated Intel MKL and Intel IPP to OneAPI v2022.2.');
    Add('   *   Updated for Embarcadero Alexandria 11.1 release (C++).');
    Add('   *   Brute-force exact K-NN algorithm on CPU with Euclidean norm distance. Faster than KD-Tree, because it scales linearly with core count. Leads GPUs in price/performance by 4x especially in double precision. Can use AI accelerators used for NNs. Due to its performance a possible alternative to deep NNs. Located in MtxForLoop.ClusteredKNN. Up to 2000x faster than naive implementations for large problems.');
    Add('   *   Fixed bug. When setting TMtxForLoop.ThreadCount, an Access Violation could be raised (thread race condition).');
    Add('   *   Fixed bug. When launching TMtxForLoop thread execution, the call could deadlock (thread race condition).');
    Add('   *   The memory cache of TVecInt and TMtxInt was not active and this caused performance degradation in the case of threading.');
    Add('');

    Add('   List of new features in v6.0.6:');
    Add('');
    Add('   Core product:');
    Add('   *   Added support for OpenCL 3.0.');
    Add('   *   New options for reporting build errors of OpenCL kernels.');
    Add('   *   Added ability to read/write VectorInt/MatrixInt to/from GPU.');
    Add('   *   Added possibility to declare arbitrary size of clVector and clMatrix with GPU memory not from object cache.');
    Add('   *   Updated with latest Intel OneAPI IPP and MKL (2021 Update 4) libs!');
    Add('   *   Fixed a bug affecting single precision 64bit apps resulting in invalid_instruction exception!');
    Add('');

    Add('   List of new features in v6.0.5:');
    Add('');
    Add('   Core product:');
    Add('   *   Enabled support for Delphi Alexandria 11.0.');
    Add('   *   Bug fixes when allocating objects larger than 2GB.');
    Add('');

    Add('   List of new features in v6.0.4:');
    Add('');
    Add('   Core product:');
    Add('   *   Added TVec.Hilbert algorithm variant.');
    Add('   *   Added TMtxVec.CapacityInElements, TMtxVec.CapacityInBytes. Changed behaviour of TMtxVec.Capacity.');
    Add('   *   Added DLL version into names of high performance libraries. Simplifies different versions to coexist on the same computer.');
    Add('   *   Added high performance shared libraries for Linux 64bit when using FireMonkey. The deployment is based on Intel OneAPI 2021 (Update 2). Achieves the same performance on Linux as on Windows.');
    Add('   *   Fixed performance issues related to TStringList and TStrings debugger visualizers. Especially for RAD Studio 10.4 it is recommended to turn off visualizers provided by Embarcadero, which are currently not in use, to improve the debugging speed.');
    Add('   *   Fixed a bug in ScatterByMask, when Src data vector had zero length.');
    Add('');

    Add('   List of new features in v6.0.2:');
    Add('');
    Add('   Core product:');
    Add('   *   Bug fix for TVec/TMtx/TMtxInt/TVecInt BinarySearch.');
    Add('');
    Add('   Debugger Visualizers.pas:');
    Add('   *   Greatly enhanced debugging stability and handling of nil and dangling pointers for Visualizers.');
    Add('   *   TStringList bug fix for 64bit compilers, which used wrong string length field size (allows display of millions of strings in real time).');
    Add('   *   Array visualizers now also show variable storage precision.');
    Add('   *   Bug fix for TStringGrid in 10.4 used by the TStringList visualizers, which was showing empty grid (CustomDraw passes wrong TRect size).');
    Add('   *   Greatly enhanced visualizers on iOS64, OSX64 and Android 64. Full support for inline and variable inspection from Delphi for all types, including TStringList.');
    Add('   *   Updated TCplx visualizers for regional settings, where comma is used as a decimal separator.');
    Add('');

    Add('   List of new features in v6.0:');
    Add('');
    Add('   MtxVec.pas, AbstractMtxVec, MtxVecBase, MtxVecUtils,...:');
    Add('   *   TVec and TMtx have a new FloatPrecision property which defines run-time floating point precision (single 32bit or double 64bit). ');
    Add('       Ideally, you can write code once and have it then executed in either double or single precision. Additionally it is possible to use ');
    Add('       the most suitable precision for math anywhere in the same application.');
    Add('   *   New "Capacity" property for TVec and TMtx. Similar to TStringList.Capacity reduces the need for memory re-allocations up to ');
    Add('       user specified size. Usefull for multi-threaded algorithms where TVec and TMtx are not from object cache.');
    Add('   *   Most units and routines updated to support user selectable floating point precision at run-time.');
    Add('');
    Add('   List of new features in v5.4:');
    Add('');
    Add('   MtxVec.pas and MtxVecInt.pas:');
    Add('   *   Added support for Delphi RIO (XE 10.3).');
    Add('   *   Updated to latest version of Intel MKL, Intel IPP (release 2019).');
    Add('   *   Vectorized version for FindIndexes, FindMask and FindAndGather for TVec/TMtx and TVecInt/TMtxInt. Especially ');
    Add('       when using FindMask, speed improvement of 10x or more is possible when vectorizing if-then clauses.');
    Add('   *   Added example to MtxVec demo: "Vectorizing if-then with masks" to show how to use vectorized FindMask and FindIndexes.');
    Add('   *   Dll API has changed. To prevent version conflicts, the library names have new version number: 6. VC runtime library is no longer needed.');
    Add('   *   MtxVec.Sparse6.dll has been joined in to MtxVec.Lapack6d.dll due to relatively much smaller size.');
    Add('   *   Installer (Build Tool) support for all Delphi platforms.');
    Add('   *   CPU Affinity support added to DoForLoop on Windows.');
    Add('   *   Added new example to MtxVec demo: "Memory channels" exploring options to speed up code that cant be vectorized at all or only partially.');
    Add('   *   Optimization methods can now respond to a "stop" signal when running in its own thread. This can be helpfull, ');
    Add('       if the optimization process would deadlock or run too long.');
    Add('   *   Added single precision support to Pardiso sparse solver.');
    Add('   *   Added single precision support to Trust-Region optimization method.');
    Add('   *   Various FireMonkey related fixes and refinments.');
    Add('');
    Add('   List of new features in v5.3:');
    Add('');
    Add('   MtxVec.pas and MtxVecInt.pas:');
    Add('   *   Added support for Apple Acccelerate framework on iOS and macOS. Includes accelerated versions of FFT, BLAS 1,2,3 and Lapack.');
    Add('   *   Support for complex-number Lapack on iOS and OSX for MtxVec Core Edition.');
    Add('   *   Substantial improvement of speed of Math functions: sin, cos, log, exp,.. on Android, ');
    Add('       iOS and OS X. Math387 now bypasses default Delphi System unit math functions. ');
    Add('   *   Vectorized versions use the Accelerate framework on the iOS and OS X. Average speedup is about 20x.');
    Add('   *   Added support for TMtxInt and Matrix to the Debugger Visualizer.');
    Add('   *   Debugger Visualizer bug fix, which helps more variables to be successfully evaluted.');
    Add('');
    Add('   List of new features in v5.2:');
    Add('');
    Add('   MtxVec.pas and MtxVecInt.pas:');
    Add('   *   Added integer matrix (TMtxInt and MatrixInt) covering 108+ overloaded functions ');
    Add('   *   Added TVec.BinarySearch and TMtx.BinarySearch for exact and nearest index on sorted data.');
    Add('   *   Added 80 new optimized functions for integer math used by TVecInt and TMtxInt.');
    Add('   *   Added ThreadIndex parameter to the MtxForLoop threaded function type');
    Add('   ');
    Add('   MtxParseExpr.pas:');
    Add('   *   Added integer, integer vector, integer matrix, boolean, boolean vector and boolean matrix types. ');
    Add('   *   Support for funtions with multiple results: (a,b,c....) = fun(d)');
    Add('   *   Added all functions from Probabilities.pas to the expression parser.');
    Add('   *   Added large set of functions from MtxVec.pas to the expression parser, like FFT, FFT2D, SVD, etc.. ');
    Add('   *   Total of 300+ functions and operators now available to the expression parser.');
    Add('   *   Fixed a number of defects and improved error reporting. Performance optimization.');
    Add('');
    Add('   List of new features in v5.1.1:');
    Add('');
    Add('   MtxVec.pas and MtxVecInt.pas:');
    Add('   *   Added TVecInt.ThresholdGT_LT.');
    Add('   *   Added ThreshAbsGt and ThreshAbsLt to TVecInt, TVec and TMtx.');
    Add('   *   Added TVecInt.BinarySearch, TVecInt.Find');
    Add('   *   Updated Intel MKL and Intel IPP related code to latest revision.');
    Add('   *   Fixed a problem with MKL VML user side multi-threading. (MtxVec.Vmld.dll)');
    Add('   *   Fix for TMtxComponentList.Count when reducing value. ');
    Add('');
    Add('   MtxVecTee.pas:');
    Add('   *   Increased color count from 3 to 5. Greatly increased the possibility of possible color combinations palette designs. ');
    Add('   *   Improved support for fixed user-specified scale.');
    Add('');
    Add('   List of new features in v5.1:');
    Add('');
    Add('   Core product:');
    Add('   *   Cross platform support including OS X, iOS and Android.');
    Add('   *   Improved performance of Lapack routines via latest Intel MKL update.');
    Add('   *   Improved performance of math routines via Intel IPP v9 update. ');
    Add('       Important: MtxVec.Spld5.dll replaced with MtxVec.Dsp5d.dll. ');
    Add('   *   Support for Rad Studio 10.1 Berlin.');
    Add('   *   Added TMtx.Filter2D usefull for 2D convolution of images.');
    Add('');
    Add('   List of new features in v5.02:');
    Add('');
    Add('   Core product:');
    Add('   *   Internal memory access optimization giving performance improvements on both 32bit and 64bit code (on Windows) ');
    Add('       from 10 to 100% depending on algorithm. The greatest improvement can been seen for algorithms using long vectors ');
    Add('       and smallest for algorithms which are using block processing.');
    Add('   *   Certified support for Android. New Chapter added to MtxVec Users Guide about Delphi mobile compiler support.');
    Add('   *   Update to MtxVec demo for FireMonkey to run also on Android tablets.');
    Add('   *   Various performance enhancements affecting automatic reference counting on Delphi mobile compilers.');
    Add('   *   Fixes to debugger visualizer affecting VectorInt and TVecInt. Additional simplifications will keep all visualizers working in more demanding debug cases.');
    Add('   *   Fixed NormL1 and NormL2 functions on 64bit, complex number and single precision.');
    Add('   *   Fixes for TMtx.Eig() on 64bit and single precision.');
    Add('   *   Support for XE8 and related TeeChart updates.');
    Add('');
    Add('   List of new features in v5.0:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Optional build parameter (MtxVec Core Edition) results in 100% full source code in pascal. (allows for portability to Android, iOS, OSx when used together with FireMonkey.).');
    Add('   *   Added support for annoynmous methods to TMtxForLoop.');
    Add('   *   New example (MtxVecThreading.pas) with description about efficient multi-threading in MtxVec Users Guide.pdf.');
    Add('   *   Enhanced string formating and automatic column sizing in Debugger Visualizers.');
    Add('   *   Adapted TMtxGridSeries to support latest TeeChart version (released sept. 2014).');
    Add('');
    Add('');
    Add('   List of new features in v4.4:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Added support for Firemonkey on Windows.');
    Add('   *   Added BitPack, ButUnpack methods and Bits property to TVecInt.');
    Add('   *   Added help for Median filter functions.');
    Add('');
    Add('');
    Add('   List of new features in v4.3:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Support for Delphi and C++Builder XE5.');
    Add('   *   Fixed performance issues with debugger visualizers in big applications.');
    Add('   *   Added support for GDI+ Canvas of TeeChart 2013.');
    Add('   *   Concurrent use of double and single precision version of the library in the same unit throug Dew.Double and Dew.Single namespaces. Introduced VectorSingle, VectorDouble and MatrixSingle, MatrixDouble type aliases.');
    Add('   *   Updated debugger visualizers to support concurrent precision use.');
    Add('   *   Added TMtx.LUSolve overload, which makes use of a precomputed factorization.');
    Add('');
    Add('');
    Add('   List of new features in v4.22:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Support for Delphi and C++Builder XE4.');
    Add('   *   Support for Steema TeeChart 2013.');
    Add('   *   Cougar Open CL support for VS.NET');
    Add('   *   Several minor bug fixes.');
    Add('');
    Add('');
    Add('   List of new features in v4.21:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Support for Delphi and C++Builder XE3.');
    Add('   *   Cougar Open CL now works with non unicode Delphi versions (2006 and 2007)');
    Add('   *   Cougar Open CL now detects also MtxVec version change and automatically rebuilds Open CL source.');
    Add('   *   Fixed C++ function operator for sVector.');
    Add('   *   Fixed memory allocation for 64bit TMtx, which only allowed 32bit range.');
    Add('   *   Bug fix for complex version of the TMtx.SVD function.');
    Add('   *   Recreated and updated C++ Demo for many C++Builder versions.');
    Add('');
    Add('');
    Add('   List of new features in v4.2:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Introduction of Cougar Open CL parallel reduction based algorithms. ' +
        'Support for sum, norms, average, min, max, dot product, etc... known ' +
        'from MtxVec supported for all precisions and platforms. Parallel reduction ' +
        'allows non-destructive summation process and makes it possible for single ' +
        'precision math to achieve same or higher accuracy than double precision for ' +
        'algorithms relying on summation of long arrays.');
    Add('   *   Performance of Cougar Open CL is now completely invariant to the ' +
        'length of the vector or size of the matrix. The programmer needs not ' +
        'to worry about memory alignment or vector size.');
    Add('   *   Updated help and tested with XE2 Update 4 and TeeChart 2012.');
    Add('   *   Multiple enhancements regarding C++.');
    Add('   *   Updated code related to Intel IPP and MKL libraries to the ' +
        'latest version. Note that the minimum CPU requirement has been ' +
        'raised by Intel to SSE2 capable CPU (P4, released in year 2000). ' +
        'AMD was still selling new CPUs without SSE2 in 2006. This limitation ' +
        'was first introduced by Intel in 2009. MtxVec v4.1 was the last ' +
        'version with the capability to support older CPUs (generic x86 code). ' +
        'The new dlls improve performance mostly for the new generation ' +
        'of CPUs, capable of SSE4.2 and Intel AVX instruction sets. ' +
        'According to Intel these can sometimes reach cca 60%. Old dlls ' +
        'may cause "instruction not recognized" exception on the latest ' +
        'generation of Intel CPUs.');
    Add('   *   Debugger visualizers have been enhanced for Delphi to support '+
        'Open CL vector and matrix types: clVector and clMatrix.');

    Add('');
    Add('');
    Add('   List of new features in v4.1:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Cougar Open CL opens the world of GPU processing to Delphi developers. Two new units clMtxVec and clMtxExpr ' +
        'add two new types clVector and clMatrix which can run their functions on the GPU.');
    Add('   *   Cougar Open CL substantially simplifies custom Open CL algorithm development, integration and deployment.');
    Add('   *   Support for TeeChart 2011.');
    Add('   *   Support for Delphi XE2 and its 64bit compiler.');
    Add('');
    Add('');
    Add('   List of new features in v4.0:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Multi-precision integer vector math with TVecInt and VectorInt with ' +
        'full support for object cache and math expressions.');
    Add('   *   Support for TeeChart 2010.');
    Add('   *   Updated dlls for latest version of MKL and IPP with support for Intel AVX.');
    Add('   *   Reduced distribution size with FFT core cross-platform fallback code providing FFT ' +
        'functions (1D and 2D) with reasonable performance without external dlls.');
    Add('   *   Reduced distribution size with IPP core cross-platform fallback code providing signal processing ' +
        'functions with reasonable performance without external dlls.');
    Add('');
    Add('   Visualizers:');
    Add('');
    Add('   *   Debugger for Delphi 2010 and later supports formated tooltips for Vector/Matrix/TVec/TMtx.');
    Add('   *   TCplx type will display as a + bi on the tooltip and in the evaluator.');
    Add('   *   Fixed a bug for string lists where empty lines were left out.');
    Add('');
    Add('   Threading:');
    Add('');
    Add('   *   Fixed a bug with TMtxForLoop when ResponseTime was set to zero and ' +
        'improved responsivness of the thread pool to just 2us which allows ' +
        'threading of very short sections of code.');
    Add('   *   Added new overloads to TMtxForLoop supporting code vectorization ' +
        'within launched threads.');
    Add('');
    Add('   Polynoms:');
    Add('');
    Add('   *   Fixed a bug for unsorted linear interpolation.');
    Add('');
    Add('   List of new features in v3.52:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   New and enhanced debugger visualizer allows charting/viewing of arrays, ' +
        'vectors (TVec/Vector) and matrices (TMtx/Matrix) while debugging. ');
    Add('   *   Multiple visualizer windows can remain open concurrently while stepping through code with F8. ' +
        'Expressions and scripting allow manipulation of debugger data. ');
    Add('   *   New strings and stringlist visualizer. Added support for 2D arrays.' +
        'Docked windows persist between debugging sessions. ');
    Add('   *   New threaded for-loop component joins simplicity of use ' +
        'with excellent performance. ');
    Add('   *   New super-conductive object cache implementation features ' +
        'linear scaling with number of threads and enables concurrency ' +
        'of math expressions which can now be threaded. MtxVec now allows ' +
        'perfect scaling of its code across any number of cores via TMtxThread.');
    Add('   *   Support for Delphi 2010 and integration of debugger visualizers in to the new IDE features.');
    Add('');
    Add('');
    Add('   List of new features in v3.5:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   Debugger visualizer allows charting/viewing of arrays, ' +
        'vectors (TVec/Vector) and matrices (TMtx/Matrix) while debugging. ' +
        'It is possible to examine huge structures (hundreds of Mbytes) ' +
        'in real time both for viewing and charting. ' +
        'Delphi default debugger only shows arrays up to 132 000 elements. ');
    Add('   *   New code optimizations and multithreaded functions.');
    Add('   *   Support for SSE4.1 for Intel Core 2 Wolfdale from Intel MKL v10 and IPP v6.');
    Add('   *   Substantially updated help file system.');
    Add('');
    Add('   MtxVecTee.pas:');
    Add('');
    Add('   *   New TeeChart series TMtxFastLineSeries allows zoom in/out with pixeldownsample ' +
        'enabled internally. Applicable also to the DrawIt method and debugger Visualizer.');
    Add('   *   TMtxFastLineSeries is 3x faster than TFastLineSeries when not using pixeldownsample.');
    Add('');
    Add('   Expression parser/scripter:');
    Add('');
    Add('   *   Function overloading allowed based on parameter count.');
    Add('   *   Custom functions can be object methods.');
    Add('   *   Vectors and matrices can be accessed by elements a(i) or m(r,c).');
    Add('   *   Colon operator allows selection of ranges of rows and colums m(:), m(1,:), v(2:3).');
    Add('   *   Assign operator supports colon operator: m(2:3) = 4.');
    Add('   *   Colon operator supports step <> 1 and allows: m(10:-1:3) = 4');
    Add('   *   Vectors and matrices can return elements from conditions: a = m(m > 4)');
    Add('   *   Functions accept strings as parameters and can return string as result.');
    Add('');
    Add('   Optimization.pas:');
    Add('');
    Add('   *   Added several linear programming algorithms, including Dual Simplex, Two Phase Simplex ordinary Simplex LP and Gomory''s Cutting Plane (CPA) algorithms.');
    Add('');
    Add('   MtxVecTools.pas:');
    Add('');
    Add('   *   New TMtxLP component for easy usage of all LP algorithms.');
    Add('');
    Add('');
    Add('   List of new features in v3.0.1:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   New code optimizations for Intel Penryn, SSE4a.');
    Add('   *   Support for Intel MKL v10.');
    Add('   *   Bug fixes for single precision and Delphi.NET.');
    Add('   *   Improvements to help files (see also links, more examples');
    Add('   *   Installers and recompile tools have been improved to work well on Vista 32 and Vista x64.');
    Add('   *   More in-depth multi-core tested dlls.');
    Add('');
    Add('   Sparse.pas :');
    Add('');
    Add('   *   Out of core solver support for Pardiso sparse solvers.');
    Add('   *   Better support (more settings) for ill-conditioned sparse matrices for Pardiso.');
    Add('');
    Add('');
    Add('   List of new features in v3.0:');
    Add('');
    Add('   Core product:');
    Add('');
    Add('   *   New code optimizations and support for Intel Core 2 Duo product familiy.');
    Add('   *   New multithreaded VML function support. Simple functions like Sin, Cos.. ' +
        'are threaded when vector length exceeds about 10 000 elements. No MtxVec code change ' +
        'required to have your code run on multiple cores.');
    Add('   *   Together with Vector/Matrix classes it is possible to write math expressions in its ' +
        'natural format and have the code at the same time executed on multiple cores!');
    Add('   *   LAPACK v3.1 delivers increased precision and performance.');
    Add('   *   Reduced distribution size with "Compact MtxVec". In case of the Stats Master by 50%. '
      + 'There are now more and more specialized dll''s. ');
    Add('   *   Intel MKL 9.1 and Intel IPP 5.2 updated with the Intel v10 C++ and Fortran compilers. ');
    Add('   *   Sparse solver: UMFPACK support updated to v5.1');
    Add('   *   Pardiso sparse solver support updated to latest version of MKL.');
    Add('   *   New HTML Help 2 format of the help file.');
    Add('   *   Support for Delphi 2007 and C++Builder 2007.');
    Add('   *   New set of true color 24x24 and 16x16 icons for components to support ' +
        'newer IDE tool palette.');
    Add('');
    Add('   Optimization.pas :');
    Add('');
    Add('   *   Simplex algorithm now supports lower and/or upper bounds for parameters.');
    Add('   *   Added Trust Region (TR) algorithm. Now it''s possible to find unbounded '
      + 'or bounded minimum of vector function of several variables.');
    Add('');
    Add('   Probabilities.pas :');
    Add('');
    Add('   *   Added 8 new distributions: Gumbel (minimum), Gumbel (maximum), Erlang, Power, '
      + 'Inverse Gaussian, Fatigue Life, Johnson SB, Johnson UB. Probabilities unit now includes 34 different distributions.');
    Add('   *   Moved distribution statistical parameter calculation from Statistics.pas to Probabilities.pas. Basic '
      + 'statistics now includes estimates for distribution mean, variance, skewness and kurtosis.');
    Add('');
    Add('   MtxExpr.pas :');
    Add('');
    Add('   *   All TVec/TMtx methods are now also available from Vector/Matrix. '
      + 'It is now possible to completely replace TVec/TMtx with Vector/Matrix.');
    Add('   *   Many new functions have been added where previously methods were needed, '
      + 'because Vector and Matrix are now value objects and can return a value.');
    Add('   *   Vector/Matrix syntax is now the default syntax. (Biggest change!) '
      + 'Old style TVec/TMtx code will still compile.');
    Add('   *   Loads of new syntax options and simplifications with support for operator overloading.'
      + 'Vector can passed as a parameter to functions accepting TVec, TMtxVec or double dynamic array as a paramter.');
    Add('   *   World class performance when evaluating Vector/Matrix expressions. ' +
        'Nealy no performance loss in compare to using CreateIt/FreeIt.');
    Add('   *   Help updated to the new Vector/Matrix syntax.');
    Add('');
    Add('   MtxGrid.pas :');
    Add('');
    Add('   *   New TMtxVecGrid control (derived from TCustomGrid) allows '
      + 'easy viewing and editing of real or complex vector or matrix. The '
      + 'same control is now used in MtxVecEdit.pas unit. It now allows real-time '
      + 'browsing of matrices with milions and bilions of elements.' );
    Add('');
    Add('   MtxIntDiff.pas :');
    Add('');
    Add('   *   New unit introduces several routines for numerical integration (1D, 2D, n-D).');
    Add('   *   All numerical gradient estimation routines moved from Optimization.pas unit.');
    Add('');
    Add('   MtxVecTee.pas :');
    Add('');
    Add('   *   Many enhancements to the TMtxGridSeries include support for rainbow palette '
      + 'and up to three levels of color mixing with top and bottom clip-off.' );
    Add('   *   Updated with support for TeeChart v8.');
    Add('');
    Add('   Help file :');
    Add('');
    Add('   *   Help file has received a major upgrade to Html Help 2 format.');
    Add('   *   Nearly all examples have been extended with C++ and C# examples.');
    Add('   *   New easier to read and navigate look and feel.');
    Add('   *   Code examples have been updated to relfect the new default ' +
        'syntax with Vector and Matrix objects.');
    Add('   *   Html Help 2 format integrates in to the IDE and F1 is again functional ' +
        'across all products.');
    Add('   *   Demo updated with Vector/Matrix syntax.');
    Add('');
  end;
end;

initialization
  RegisterClass(TfrmChanges30);

end.
