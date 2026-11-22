{ PasMuJoCo - Object Pascal header for the MuJoCo 3.17.0 C API.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE).

  Contains translations of the MuJoCo C headers,
  Copyright 2021 DeepMind Technologies Limited, Apache License 2.0.

  *** GENERATED FILE - DO NOT EDIT. ***
  Produced by tools/generate_header.py from tools/PasMuJoCo.template.pas and
  MuJoCo's own API metadata. Edit the template or the generator instead.

  Conventions
  - Type, field, constant and function names are the C names, so the MuJoCo
    documentation applies directly. A pointer type is the C name with a
    "P" prefix (PmjModel = ^mjModel).
  - Enums are Int32 aliases plus untyped constants (mjtGeom, mjGEOM_PLANE),
    so bit flags can be combined with "or" just as in C.
  - Field names that are Pascal reserved words are escaped: geom.&type.
  - Every API function is a variable holding a function pointer
    (mj_step: Tmj_step). They are nil until LoadMuJoCoLibrary succeeds.
  - Library variables (mjcb_control, mjDISABLESTRING, ...) are pointers to the
    variable inside the library: mjcb_control^ := @MyControlCallback;
  - Not translated: the mjui_* OpenGL/GLFW user-interface API, and the
    variadic arguments of mju_error, mju_warning and mju_info (pass a
    finished message with no "%" characters).
  - Fixed-size C arrays are zero-based Pascal arrays; arrays in function
    parameters are pointers to the first element, as in C. }

unit PasMuJoCo;

{$i PasMuJoCo.inc}

interface

uses
{$ifdef fpc}
  dynlibs, SysUtils;
{$else}
  {$ifdef MSWINDOWS}Winapi.Windows,{$endif} System.SysUtils;
{$endif}

const
{$ifdef PasMuJoCoWindows}
  MuJoCoLibraryName = 'mujoco.dll';
{$else}
  MuJoCoLibraryName = 'libmujoco.so';
{$endif}

  // MuJoCo version these declarations were generated from (major*1000000 + minor*1000 + patch).
  mjVERSION_HEADER = 3017000;

  //---------------------------------------------------------------------------
  // constants

  mjMINVAL = 1E-15;                      // minimum value in any denominator
  mjMAXVAL = 1E+10;                      // maximum value in qpos, qvel, qacc
  mjPI = 3.14159265358979323846;
  mjMINMU = 1E-5;                        // minimum friction coefficient
  mjMINIMP = 0.0001;                     // minimum constraint impedance
  mjMAXIMP = 0.9999;                     // maximum constraint impedance
  mjMAXCONPAIR = 50;                     // maximum number of contacts per geom pair
  mjMAXTREEDEPTH = 50;                   // maximum bounding volume hierarchy depth
  mjMAXFLEXNODES = 27;                   // maximum number of flex nodes
  mjMINAWAKE = 10;                       // minimum number of timesteps before sleeping
  mjNEQDATA = 12;                        // number of eq_data fields
  mjNDYN = 10;                           // number of actuator dynamics parameters
  mjNGAIN = 10;                          // number of actuator gain parameters
  mjNBIAS = 10;                          // number of actuator bias parameters
  mjNFLUID = 12;                         // number of fluid interaction parameters
  mjNREF = 2;                            // number of solver reference parameters
  mjNIMP = 5;                            // number of solver impedance parameters
  mjNPOLY = 2;                           // number of high-order polynomial coefficients
  mjNSENS = 3;                           // number of sensor parameters
  mjNSOLVER = 200;                       // size of one mjData.solver array
  mjNISLAND = 20;                        // number of mjData.solver arrays
  mjNGROUP = 6;                          // number of geom, site, joint, skin groups with visflags
  mjMAXLIGHT = 100;                      // maximum number of lights in a scene
  mjMAXOVERLAY = 500;                    // maximum number of characters in overlay text
  mjMAXLINE = 100;                       // maximum number of lines per plot
  mjMAXLINEPNT = 1001;                   // maximum number points per line
  mjMAXPLANEGRID = 200;                  // maximum number of grid divisions for plane
  mjNAUX = 10;                           // number of auxiliary buffers
  mjMAXTEXTURE = 1000;                   // maximum number of textures
  mjMAXMATERIAL = 1000;                  // maximum number of materials with textures

  //---------------------------------------------------------------------------
  // enum values

  // mjtDisableBit
  mjDSBL_CONSTRAINT = 1;
  mjDSBL_EQUALITY = 2;
  mjDSBL_FRICTIONLOSS = 4;
  mjDSBL_LIMIT = 8;
  mjDSBL_CONTACT = 16;
  mjDSBL_SPRING = 32;
  mjDSBL_DAMPER = 64;
  mjDSBL_GRAVITY = 128;
  mjDSBL_CLAMPCTRL = 256;
  mjDSBL_WARMSTART = 512;
  mjDSBL_FILTERPARENT = 1024;
  mjDSBL_ACTUATION = 2048;
  mjDSBL_REFSAFE = 4096;
  mjDSBL_SENSOR = 8192;
  mjDSBL_MIDPHASE = 16384;
  mjDSBL_EULERDAMP = 32768;
  mjDSBL_AUTORESET = 65536;
  mjDSBL_NATIVECCD = 131072;
  mjDSBL_ISLAND = 262144;
  mjDSBL_MULTICCD = 524288;
  mjNDISABLE = 20;

  // mjtEnableBit
  mjENBL_OVERRIDE = 1;
  mjENBL_ENERGY = 2;
  mjENBL_FWDINV = 4;
  mjENBL_INVDISCRETE = 8;
  mjENBL_SLEEP = 16;
  mjENBL_DIAGEXACT = 32;
  mjENBL_IPC = 64;
  mjNENABLE = 7;

  // mjtJoint
  mjJNT_FREE = 0;
  mjJNT_BALL = 1;
  mjJNT_SLIDE = 2;
  mjJNT_HINGE = 3;

  // mjtGeom
  mjGEOM_PLANE = 0;
  mjGEOM_HFIELD = 1;
  mjGEOM_SPHERE = 2;
  mjGEOM_CAPSULE = 3;
  mjGEOM_ELLIPSOID = 4;
  mjGEOM_CYLINDER = 5;
  mjGEOM_BOX = 6;
  mjGEOM_MESH = 7;
  mjGEOM_SDF = 8;
  mjNGEOMTYPES = 9;
  mjGEOM_ARROW = 100;
  mjGEOM_ARROW1 = 101;
  mjGEOM_ARROW2 = 102;
  mjGEOM_LINE = 103;
  mjGEOM_LINEBOX = 104;
  mjGEOM_FLEX = 105;
  mjGEOM_SKIN = 106;
  mjGEOM_LABEL = 107;
  mjGEOM_TRIANGLE = 108;
  mjGEOM_NONE = 1001;

  // mjtProjection
  mjPROJ_PERSPECTIVE = 0;
  mjPROJ_ORTHOGRAPHIC = 1;

  // mjtCamLight
  mjCAMLIGHT_FIXED = 0;
  mjCAMLIGHT_TRACK = 1;
  mjCAMLIGHT_TRACKCOM = 2;
  mjCAMLIGHT_TARGETBODY = 3;
  mjCAMLIGHT_TARGETBODYCOM = 4;

  // mjtLightType
  mjLIGHT_SPOT = 0;
  mjLIGHT_DIRECTIONAL = 1;
  mjLIGHT_POINT = 2;
  mjLIGHT_IMAGE = 3;

  // mjtTexture
  mjTEXTURE_2D = 0;
  mjTEXTURE_CUBE = 1;
  mjTEXTURE_SKYBOX = 2;

  // mjtTextureRole
  mjTEXROLE_USER = 0;
  mjTEXROLE_RGB = 1;
  mjTEXROLE_OCCLUSION = 2;
  mjTEXROLE_ROUGHNESS = 3;
  mjTEXROLE_METALLIC = 4;
  mjTEXROLE_NORMAL = 5;
  mjTEXROLE_OPACITY = 6;
  mjTEXROLE_EMISSIVE = 7;
  mjTEXROLE_RGBA = 8;
  mjTEXROLE_ORM = 9;
  mjNTEXROLE = 10;

  // mjtColorSpace
  mjCOLORSPACE_AUTO = 0;
  mjCOLORSPACE_LINEAR = 1;
  mjCOLORSPACE_SRGB = 2;

  // mjtIntegrator
  mjINT_EULER = 0;
  mjINT_RK4 = 1;
  mjINT_IMPLICIT = 2;
  mjINT_IMPLICITFAST = 3;
  mjINT_DISCRETE = 4;

  // mjtCone
  mjCONE_PYRAMIDAL = 0;
  mjCONE_ELLIPTIC = 1;

  // mjtJacobian
  mjJAC_DENSE = 0;
  mjJAC_SPARSE = 1;
  mjJAC_AUTO = 2;

  // mjtSolver
  mjSOL_PGS = 0;
  mjSOL_CG = 1;
  mjSOL_NEWTON = 2;

  // mjtEq
  mjEQ_CONNECT = 0;
  mjEQ_WELD = 1;
  mjEQ_JOINT = 2;
  mjEQ_TENDON = 3;
  mjEQ_FLEX = 4;
  mjEQ_FLEXVERT = 5;
  mjEQ_FLEXSTRAIN = 6;
  mjEQ_DISTANCE = 7;

  // mjtWrap
  mjWRAP_NONE = 0;
  mjWRAP_JOINT = 1;
  mjWRAP_PULLEY = 2;
  mjWRAP_SITE = 3;
  mjWRAP_SPHERE = 4;
  mjWRAP_CYLINDER = 5;

  // mjtTrn
  mjTRN_JOINT = 0;
  mjTRN_JOINTINPARENT = 1;
  mjTRN_SLIDERCRANK = 2;
  mjTRN_TENDON = 3;
  mjTRN_SITE = 4;
  mjTRN_BODY = 5;
  mjTRN_SO3 = 6;
  mjTRN_UNDEFINED = 1000;

  // mjtDyn
  mjDYN_NONE = 0;
  mjDYN_INTEGRATOR = 1;
  mjDYN_FILTER = 2;
  mjDYN_FILTEREXACT = 3;
  mjDYN_MUSCLE = 4;
  mjDYN_DCMOTOR = 5;
  mjDYN_PID = 6;
  mjDYN_USER = 7;

  // mjtGain
  mjGAIN_FIXED = 0;
  mjGAIN_AFFINE = 1;
  mjGAIN_MUSCLE = 2;
  mjGAIN_DCMOTOR = 3;
  mjGAIN_SO3 = 4;
  mjGAIN_PID = 5;
  mjGAIN_USER = 6;

  // mjtBias
  mjBIAS_NONE = 0;
  mjBIAS_AFFINE = 1;
  mjBIAS_MUSCLE = 2;
  mjBIAS_DCMOTOR = 3;
  mjBIAS_SO3 = 4;
  mjBIAS_USER = 5;

  // mjtCtrlChart
  mjCHART_EXPMAP = 1;
  mjCHART_QUAT = 2;

  // mjtCtrlInput
  mjINPUT_POS = 1;
  mjINPUT_VEL = 2;
  mjINPUT_FF = 4;
  mjINPUT_VOLTAGE = 8;
  mjINPUT_NONE = 16;
  mjINPUT_PRESSURE = 32;

  // mjtObj
  mjOBJ_UNKNOWN = 0;
  mjOBJ_BODY = 1;
  mjOBJ_XBODY = 2;
  mjOBJ_JOINT = 3;
  mjOBJ_DOF = 4;
  mjOBJ_GEOM = 5;
  mjOBJ_SITE = 6;
  mjOBJ_CAMERA = 7;
  mjOBJ_LIGHT = 8;
  mjOBJ_FLEX = 9;
  mjOBJ_MESH = 10;
  mjOBJ_SKIN = 11;
  mjOBJ_HFIELD = 12;
  mjOBJ_TEXTURE = 13;
  mjOBJ_MATERIAL = 14;
  mjOBJ_PAIR = 15;
  mjOBJ_EXCLUDE = 16;
  mjOBJ_EQUALITY = 17;
  mjOBJ_TENDON = 18;
  mjOBJ_ACTUATOR = 19;
  mjOBJ_SENSOR = 20;
  mjOBJ_NUMERIC = 21;
  mjOBJ_TEXT = 22;
  mjOBJ_TUPLE = 23;
  mjOBJ_KEY = 24;
  mjOBJ_PLUGIN = 25;
  mjNOBJECT = 26;
  mjOBJ_FRAME = 100;
  mjOBJ_DEFAULT = 101;
  mjOBJ_MODEL = 102;

  // mjtSensor
  mjSENS_TOUCH = 0;
  mjSENS_ACCELEROMETER = 1;
  mjSENS_VELOCIMETER = 2;
  mjSENS_GYRO = 3;
  mjSENS_FORCE = 4;
  mjSENS_TORQUE = 5;
  mjSENS_MAGNETOMETER = 6;
  mjSENS_RANGEFINDER = 7;
  mjSENS_CAMPROJECTION = 8;
  mjSENS_JOINTPOS = 9;
  mjSENS_JOINTVEL = 10;
  mjSENS_TENDONPOS = 11;
  mjSENS_TENDONVEL = 12;
  mjSENS_ACTUATORPOS = 13;
  mjSENS_ACTUATORVEL = 14;
  mjSENS_ACTUATORFRC = 15;
  mjSENS_JOINTACTFRC = 16;
  mjSENS_TENDONACTFRC = 17;
  mjSENS_BALLQUAT = 18;
  mjSENS_BALLANGVEL = 19;
  mjSENS_JOINTLIMITPOS = 20;
  mjSENS_JOINTLIMITVEL = 21;
  mjSENS_JOINTLIMITFRC = 22;
  mjSENS_TENDONLIMITPOS = 23;
  mjSENS_TENDONLIMITVEL = 24;
  mjSENS_TENDONLIMITFRC = 25;
  mjSENS_FRAMEPOS = 26;
  mjSENS_FRAMEQUAT = 27;
  mjSENS_FRAMEXAXIS = 28;
  mjSENS_FRAMEYAXIS = 29;
  mjSENS_FRAMEZAXIS = 30;
  mjSENS_FRAMELINVEL = 31;
  mjSENS_FRAMEANGVEL = 32;
  mjSENS_FRAMELINACC = 33;
  mjSENS_FRAMEANGACC = 34;
  mjSENS_SUBTREECOM = 35;
  mjSENS_SUBTREELINVEL = 36;
  mjSENS_SUBTREEANGMOM = 37;
  mjSENS_INSIDESITE = 38;
  mjSENS_GEOMDIST = 39;
  mjSENS_GEOMNORMAL = 40;
  mjSENS_GEOMFROMTO = 41;
  mjSENS_CONTACT = 42;
  mjSENS_E_POTENTIAL = 43;
  mjSENS_E_KINETIC = 44;
  mjSENS_CLOCK = 45;
  mjSENS_TACTILE = 46;
  mjSENS_PLUGIN = 47;
  mjSENS_USER = 48;

  // mjtStage
  mjSTAGE_NONE = 0;
  mjSTAGE_POS = 1;
  mjSTAGE_VEL = 2;
  mjSTAGE_ACC = 3;

  // mjtDataType
  mjDATATYPE_REAL = 0;
  mjDATATYPE_POSITIVE = 1;
  mjDATATYPE_AXIS = 2;
  mjDATATYPE_QUATERNION = 3;

  // mjtConDataField
  mjCONDATA_FOUND = 0;
  mjCONDATA_FORCE = 1;
  mjCONDATA_TORQUE = 2;
  mjCONDATA_DIST = 3;
  mjCONDATA_POS = 4;
  mjCONDATA_NORMAL = 5;
  mjCONDATA_TANGENT = 6;
  mjCONDATA_LINVEL = 7;
  mjCONDATA_ANGVEL = 8;
  mjNCONDATA = 9;

  // mjtRayDataField
  mjRAYDATA_DIST = 0;
  mjRAYDATA_DIR = 1;
  mjRAYDATA_ORIGIN = 2;
  mjRAYDATA_POINT = 3;
  mjRAYDATA_NORMAL = 4;
  mjRAYDATA_DEPTH = 5;
  mjNRAYDATA = 6;

  // mjtCamOutBit
  mjCAMOUT_RGB = 1;
  mjCAMOUT_DEPTH = 2;
  mjCAMOUT_DIST = 4;
  mjCAMOUT_NORMAL = 8;
  mjCAMOUT_SEG = 16;
  mjNCAMOUT = 5;

  // mjtSameFrame
  mjSAMEFRAME_NONE = 0;
  mjSAMEFRAME_BODY = 1;
  mjSAMEFRAME_INERTIA = 2;
  mjSAMEFRAME_BODYROT = 3;
  mjSAMEFRAME_INERTIAROT = 4;

  // mjtSleepPolicy
  mjSLEEP_AUTO = 0;
  mjSLEEP_AUTO_NEVER = 1;
  mjSLEEP_AUTO_ALLOWED = 2;
  mjSLEEP_NEVER = 3;
  mjSLEEP_ALLOWED = 4;
  mjSLEEP_INIT = 5;

  // mjtLRMode
  mjLRMODE_NONE = 0;
  mjLRMODE_MUSCLE = 1;
  mjLRMODE_MUSCLEUSER = 2;
  mjLRMODE_ALL = 3;

  // mjtFlexSelf
  mjFLEXSELF_NONE = 0;
  mjFLEXSELF_NARROW = 1;
  mjFLEXSELF_BVH = 2;
  mjFLEXSELF_SAP = 3;
  mjFLEXSELF_AUTO = 4;

  // mjtSDFType
  mjSDFTYPE_SINGLE = 0;
  mjSDFTYPE_INTERSECTION = 1;
  mjSDFTYPE_MIDSURFACE = 2;
  mjSDFTYPE_COLLISION = 3;

  // mjtState
  mjSTATE_TIME = 1;
  mjSTATE_QPOS = 2;
  mjSTATE_QVEL = 4;
  mjSTATE_ACT = 8;
  mjSTATE_HISTORY = 16;
  mjSTATE_WARMSTART = 32;
  mjSTATE_CTRL = 64;
  mjSTATE_QFRC_APPLIED = 128;
  mjSTATE_XFRC_APPLIED = 256;
  mjSTATE_EQ_ACTIVE = 512;
  mjSTATE_MOCAP_POS = 1024;
  mjSTATE_MOCAP_QUAT = 2048;
  mjSTATE_USERDATA = 4096;
  mjSTATE_PLUGIN = 8192;
  mjNSTATE = 14;
  mjSTATE_PHYSICS = 30;
  mjSTATE_FULLPHYSICS = 8223;
  mjSTATE_USER = 8128;
  mjSTATE_INTEGRATION = 16383;

  // mjtConstraint
  mjCNSTR_EQUALITY = 0;
  mjCNSTR_FRICTION_DOF = 1;
  mjCNSTR_FRICTION_TENDON = 2;
  mjCNSTR_LIMIT_JOINT = 3;
  mjCNSTR_LIMIT_TENDON = 4;
  mjCNSTR_CONTACT_FRICTIONLESS = 5;
  mjCNSTR_CONTACT_PYRAMIDAL = 6;
  mjCNSTR_CONTACT_ELLIPTIC = 7;

  // mjtConstraintState
  mjCNSTRSTATE_SATISFIED = 0;
  mjCNSTRSTATE_QUADRATIC = 1;
  mjCNSTRSTATE_LINEARNEG = 2;
  mjCNSTRSTATE_LINEARPOS = 3;
  mjCNSTRSTATE_CONE = 4;

  // mjtWarning
  mjWARN_INERTIA = 0;
  mjWARN_CONTACTFULL = 1;
  mjWARN_CNSTRFULL = 2;
  mjWARN_BADQPOS = 3;
  mjWARN_BADQVEL = 4;
  mjWARN_BADQACC = 5;
  mjWARN_BADCTRL = 6;
  mjNWARNING = 7;

  // mjtTimer
  mjTIMER_STEP = 0;
  mjTIMER_FORWARD = 1;
  mjTIMER_INVERSE = 2;
  mjTIMER_POSITION = 3;
  mjTIMER_VELOCITY = 4;
  mjTIMER_ACTUATION = 5;
  mjTIMER_CONSTRAINT = 6;
  mjTIMER_ADVANCE = 7;
  mjTIMER_POS_KINEMATICS = 8;
  mjTIMER_POS_INERTIA = 9;
  mjTIMER_POS_COLLISION = 10;
  mjTIMER_POS_MAKE = 11;
  mjTIMER_POS_PROJECT = 12;
  mjTIMER_COL_BROAD = 13;
  mjTIMER_COL_NARROW = 14;
  mjNTIMER = 15;

  // mjtSleepState
  mjS_STATIC = -1;
  mjS_ASLEEP = 0;
  mjS_AWAKE = 1;

  // mjtLogLevel
  mjLOG_DEBUG = 0;
  mjLOG_INFO = 1;
  mjLOG_WARNING = 2;
  mjLOG_ERROR = 3;

  // mjtLogTopic
  mjTOPIC_NONE = 0;
  mjTOPIC_TIME_STP = 1;
  mjTOPIC_TIME_CMP = 2;
  mjTOPIC_SLEEP = 3;
  mjNTOPIC = 3;

  // mjtGeomInertia
  mjINERTIA_VOLUME = 0;
  mjINERTIA_SHELL = 1;

  // mjtMeshInertia
  mjMESH_INERTIA_CONVEX = 0;
  mjMESH_INERTIA_EXACT = 1;
  mjMESH_INERTIA_LEGACY = 2;
  mjMESH_INERTIA_SHELL = 3;

  // mjtMeshBuiltin
  mjMESH_BUILTIN_NONE = 0;
  mjMESH_BUILTIN_SPHERE = 1;
  mjMESH_BUILTIN_HEMISPHERE = 2;
  mjMESH_BUILTIN_CONE = 3;
  mjMESH_BUILTIN_SUPERSPHERE = 4;
  mjMESH_BUILTIN_SUPERTORUS = 5;
  mjMESH_BUILTIN_WEDGE = 6;
  mjMESH_BUILTIN_PLATE = 7;
  mjMESH_BUILTIN_GRID = 8;
  mjMESH_BUILTIN_BOX = 9;
  mjMESH_BUILTIN_CYLINDER = 10;
  mjMESH_BUILTIN_ELLIPSOID = 11;
  mjMESH_BUILTIN_SQUARE = 12;
  mjMESH_BUILTIN_DISC = 13;

  // mjtFlexSection
  mjFLEXSECTION_CIRCLE = 0;
  mjFLEXSECTION_BOX = 1;

  // mjtBuiltin
  mjBUILTIN_NONE = 0;
  mjBUILTIN_GRADIENT = 1;
  mjBUILTIN_CHECKER = 2;
  mjBUILTIN_FLAT = 3;

  // mjtMark
  mjMARK_NONE = 0;
  mjMARK_EDGE = 1;
  mjMARK_CROSS = 2;
  mjMARK_RANDOM = 3;

  // mjtLimited
  mjLIMITED_FALSE = 0;
  mjLIMITED_TRUE = 1;
  mjLIMITED_AUTO = 2;

  // mjtAlignFree
  mjALIGNFREE_FALSE = 0;
  mjALIGNFREE_TRUE = 1;
  mjALIGNFREE_AUTO = 2;

  // mjtPassthrough
  mjPASSTHROUGH_NONE = 0;
  mjPASSTHROUGH_TEXTURES = 1;

  // mjtEmbed
  mjEMBED_FALSE = 0;
  mjEMBED_TRUE = 1;
  mjEMBED_AUTO = 2;

  // mjtInertiaFromGeom
  mjINERTIAFROMGEOM_FALSE = 0;
  mjINERTIAFROMGEOM_TRUE = 1;
  mjINERTIAFROMGEOM_AUTO = 2;

  // mjtOrientation
  mjORIENTATION_QUAT = 0;
  mjORIENTATION_AXISANGLE = 1;
  mjORIENTATION_XYAXES = 2;
  mjORIENTATION_ZAXIS = 3;
  mjORIENTATION_EULER = 4;

  // mjtConflict
  mjCONFLICT_WARNING = 0;
  mjCONFLICT_MERGE = 1;
  mjCONFLICT_ERROR = 2;

  // mjtScaling
  mjSCALING_SIMILAR = 0;
  mjSCALING_GEOMETRY = 1;

  // mjtActuator
  mjACTUATOR_GENERAL = 0;
  mjACTUATOR_MOTOR = 1;
  mjACTUATOR_POSITION = 2;
  mjACTUATOR_VELOCITY = 3;
  mjACTUATOR_INTVELOCITY = 4;
  mjACTUATOR_DAMPER = 5;
  mjACTUATOR_CYLINDER = 6;
  mjACTUATOR_MUSCLE = 7;
  mjACTUATOR_ADHESION = 8;
  mjACTUATOR_PID = 9;
  mjACTUATOR_ORIENTATION = 10;
  mjACTUATOR_DCMOTOR = 11;

  // mjtCTimer
  mjCTIMER_TOTAL = 0;
  mjCTIMER_ASSETS = 1;
  mjCTIMER_TEXTURE = 2;
  mjCTIMER_MESH_LOAD = 3;
  mjCTIMER_MESH_HULL = 4;
  mjCTIMER_MESH_POLYGON = 5;
  mjCTIMER_MESH_INERTIA = 6;
  mjCTIMER_MESH_BVH = 7;
  mjCTIMER_MESH_OCTREE = 8;
  mjNCTIMER = 9;

  // mjtCatBit
  mjCAT_STATIC = 1;
  mjCAT_DYNAMIC = 2;
  mjCAT_DECOR = 4;
  mjCAT_ALL = 7;

  // mjtMouse
  mjMOUSE_NONE = 0;
  mjMOUSE_ROTATE_V = 1;
  mjMOUSE_ROTATE_H = 2;
  mjMOUSE_MOVE_V = 3;
  mjMOUSE_MOVE_H = 4;
  mjMOUSE_ZOOM = 5;
  mjMOUSE_MOVE_V_REL = 6;
  mjMOUSE_MOVE_H_REL = 7;
  mjMOUSE_TURN_V = 8;
  mjMOUSE_TURN_H = 9;

  // mjtPertBit
  mjPERT_TRANSLATE = 1;
  mjPERT_ROTATE = 2;

  // mjtCamera
  mjCAMERA_FREE = 0;
  mjCAMERA_TRACKING = 1;
  mjCAMERA_FIXED = 2;
  mjCAMERA_USER = 3;

  // mjtLabel
  mjLABEL_NONE = 0;
  mjLABEL_BODY = 1;
  mjLABEL_JOINT = 2;
  mjLABEL_GEOM = 3;
  mjLABEL_SITE = 4;
  mjLABEL_CAMERA = 5;
  mjLABEL_LIGHT = 6;
  mjLABEL_TENDON = 7;
  mjLABEL_ACTUATOR = 8;
  mjLABEL_CONSTRAINT = 9;
  mjLABEL_FLEX = 10;
  mjLABEL_SKIN = 11;
  mjLABEL_SELECTION = 12;
  mjLABEL_SELPNT = 13;
  mjLABEL_CONTACTPOINT = 14;
  mjLABEL_CONTACTFORCE = 15;
  mjLABEL_ISLAND = 16;
  mjNLABEL = 17;

  // mjtFrame
  mjFRAME_NONE = 0;
  mjFRAME_BODY = 1;
  mjFRAME_GEOM = 2;
  mjFRAME_SITE = 3;
  mjFRAME_CAMERA = 4;
  mjFRAME_LIGHT = 5;
  mjFRAME_CONTACT = 6;
  mjFRAME_WORLD = 7;
  mjNFRAME = 8;

  // mjtVisFlag
  mjVIS_CONVEXHULL = 0;
  mjVIS_TEXTURE = 1;
  mjVIS_JOINT = 2;
  mjVIS_CAMERA = 3;
  mjVIS_ACTUATOR = 4;
  mjVIS_ACTIVATION = 5;
  mjVIS_LIGHT = 6;
  mjVIS_TENDON = 7;
  mjVIS_RANGEFINDER = 8;
  mjVIS_CONSTRAINT = 9;
  mjVIS_INERTIA = 10;
  mjVIS_SCLINERTIA = 11;
  mjVIS_PERTFORCE = 12;
  mjVIS_PERTOBJ = 13;
  mjVIS_CONTACTPOINT = 14;
  mjVIS_ISLAND = 15;
  mjVIS_CONTACTFORCE = 16;
  mjVIS_CONTACTSPLIT = 17;
  mjVIS_TRANSPARENT = 18;
  mjVIS_AUTOCONNECT = 19;
  mjVIS_COM = 20;
  mjVIS_SELECT = 21;
  mjVIS_STATIC = 22;
  mjVIS_SKIN = 23;
  mjVIS_FLEXVERT = 24;
  mjVIS_FLEXEDGE = 25;
  mjVIS_FLEXFACE = 26;
  mjVIS_FLEXSKIN = 27;
  mjVIS_BODYBVH = 28;
  mjVIS_MESHBVH = 29;
  mjVIS_SDFITER = 30;
  mjNVISFLAG = 31;

  // mjtRndFlag
  mjRND_SHADOW = 0;
  mjRND_WIREFRAME = 1;
  mjRND_REFLECTION = 2;
  mjRND_ADDITIVE = 3;
  mjRND_SKYBOX = 4;
  mjRND_FOG = 5;
  mjRND_HAZE = 6;
  mjRND_DEPTH = 7;
  mjRND_SEGMENT = 8;
  mjRND_IDCOLOR = 9;
  mjRND_CULL_FACE = 10;
  mjNRNDFLAG = 11;

  // mjtStereo
  mjSTEREO_NONE = 0;
  mjSTEREO_QUADBUFFERED = 1;
  mjSTEREO_SIDEBYSIDE = 2;

  // mjtPluginCapabilityBit
  mjPLUGIN_ACTUATOR = 1;
  mjPLUGIN_SENSOR = 2;
  mjPLUGIN_PASSIVE = 4;
  mjPLUGIN_SDF = 8;

  // mjtGridPos
  mjGRID_TOPLEFT = 0;
  mjGRID_TOPRIGHT = 1;
  mjGRID_BOTTOMLEFT = 2;
  mjGRID_BOTTOMRIGHT = 3;
  mjGRID_TOP = 4;
  mjGRID_BOTTOM = 5;
  mjGRID_LEFT = 6;
  mjGRID_RIGHT = 7;

  // mjtFramebuffer
  mjFB_WINDOW = 0;
  mjFB_OFFSCREEN = 1;

  // mjtDepthMap
  mjDEPTH_ZERONEAR = 0;
  mjDEPTH_ZEROFAR = 1;

  // mjtFontScale
  mjFONTSCALE_50 = 50;
  mjFONTSCALE_100 = 100;
  mjFONTSCALE_150 = 150;
  mjFONTSCALE_200 = 200;
  mjFONTSCALE_250 = 250;
  mjFONTSCALE_300 = 300;

  // mjtFont
  mjFONT_NORMAL = 0;
  mjFONT_SHADOW = 1;
  mjFONT_BIG = 2;

  // mjrPixelFormat
  mjPIXEL_FORMAT_UNKNOWN = 0;
  mjPIXEL_FORMAT_R8 = 1;
  mjPIXEL_FORMAT_RGB8 = 2;
  mjPIXEL_FORMAT_RGBA8 = 3;
  mjPIXEL_FORMAT_R32F = 4;
  mjPIXEL_FORMAT_DEPTH32F = 5;
  mjPIXEL_FORMAT_KTX = 6;

  // mjrVertexAttributeUsage
  mjVERTEX_ATTRIBUTE_USAGE_POSITION = 0;
  mjVERTEX_ATTRIBUTE_USAGE_NORMAL = 1;
  mjVERTEX_ATTRIBUTE_USAGE_TANGENTS = 2;
  mjVERTEX_ATTRIBUTE_USAGE_UV = 3;
  mjVERTEX_ATTRIBUTE_USAGE_COLOR = 4;

  // mjrVertexAttributeType
  mjVERTEX_ATTRIBUTE_TYPE_FLOAT2 = 0;
  mjVERTEX_ATTRIBUTE_TYPE_FLOAT3 = 1;
  mjVERTEX_ATTRIBUTE_TYPE_FLOAT4 = 2;
  mjVERTEX_ATTRIBUTE_TYPE_UBYTE4 = 3;

  // mjrIndexType
  mjINDEX_TYPE_U16 = 0;
  mjINDEX_TYPE_U32 = 1;

  // mjrMeshPrimitiveType
  mjMESH_PRIMITIVE_TYPE_TRIANGLES = 0;
  mjMESH_PRIMITIVE_TYPE_LINES = 1;

  // mjtButton
  mjBUTTON_NONE = 0;
  mjBUTTON_LEFT = 1;
  mjBUTTON_RIGHT = 2;
  mjBUTTON_MIDDLE = 3;

  // mjtEvent
  mjEVENT_NONE = 0;
  mjEVENT_MOVE = 1;
  mjEVENT_PRESS = 2;
  mjEVENT_RELEASE = 3;
  mjEVENT_SCROLL = 4;
  mjEVENT_KEY = 5;
  mjEVENT_RESIZE = 6;
  mjEVENT_REDRAW = 7;
  mjEVENT_FILESDROP = 8;

  // mjtItem
  mjITEM_END = -2;
  mjITEM_SECTION = -1;
  mjITEM_SEPARATOR = 0;
  mjITEM_STATIC = 1;
  mjITEM_BUTTON = 2;
  mjITEM_CHECKINT = 3;
  mjITEM_CHECKBYTE = 4;
  mjITEM_RADIO = 5;
  mjITEM_RADIOLINE = 6;
  mjITEM_SELECT = 7;
  mjITEM_SLIDERINT = 8;
  mjITEM_SLIDERNUM = 9;
  mjITEM_EDITINT = 10;
  mjITEM_EDITNUM = 11;
  mjITEM_EDITFLOAT = 12;
  mjITEM_EDITTXT = 13;
  mjNITEM = 14;

  // mjtSection
  mjSECT_CLOSED = 0;
  mjSECT_OPEN = 1;
  mjSECT_FIXED = 2;

type
  //---------------------------------------------------------------------------
  // scalar types

{$ifdef PasMuJoCoSingle}
  mjtNum = Single;
{$else}
  mjtNum = Double;
{$endif}
  mjtByte = Byte;
  mjtSize = Int64;
  mjtBool = Boolean;                // C _Bool, one byte

  //---------------------------------------------------------------------------
  // enum types

  mjtDisableBit = Int32;
  mjtEnableBit = Int32;
  mjtJoint = Int32;
  mjtGeom = Int32;
  mjtProjection = Int32;
  mjtCamLight = Int32;
  mjtLightType = Int32;
  mjtTexture = Int32;
  mjtTextureRole = Int32;
  mjtColorSpace = Int32;
  mjtIntegrator = Int32;
  mjtCone = Int32;
  mjtJacobian = Int32;
  mjtSolver = Int32;
  mjtEq = Int32;
  mjtWrap = Int32;
  mjtTrn = Int32;
  mjtDyn = Int32;
  mjtGain = Int32;
  mjtBias = Int32;
  mjtCtrlChart = Int32;
  mjtCtrlInput = Int32;
  mjtObj = Int32;
  mjtSensor = Int32;
  mjtStage = Int32;
  mjtDataType = Int32;
  mjtConDataField = Int32;
  mjtRayDataField = Int32;
  mjtCamOutBit = Int32;
  mjtSameFrame = Int32;
  mjtSleepPolicy = Int32;
  mjtLRMode = Int32;
  mjtFlexSelf = Int32;
  mjtSDFType = Int32;
  mjtState = Int32;
  mjtConstraint = Int32;
  mjtConstraintState = Int32;
  mjtWarning = Int32;
  mjtTimer = Int32;
  mjtSleepState = Int32;
  mjtLogLevel = Int32;
  mjtLogTopic = Int32;
  mjtGeomInertia = Int32;
  mjtMeshInertia = Int32;
  mjtMeshBuiltin = Int32;
  mjtFlexSection = Int32;
  mjtBuiltin = Int32;
  mjtMark = Int32;
  mjtLimited = Int32;
  mjtAlignFree = Int32;
  mjtPassthrough = Int32;
  mjtEmbed = Int32;
  mjtInertiaFromGeom = Int32;
  mjtOrientation = Int32;
  mjtConflict = Int32;
  mjtScaling = Int32;
  mjtActuator = Int32;
  mjtCTimer = Int32;
  mjtCatBit = Int32;
  mjtMouse = Int32;
  mjtPertBit = Int32;
  mjtCamera = Int32;
  mjtLabel = Int32;
  mjtFrame = Int32;
  mjtVisFlag = Int32;
  mjtRndFlag = Int32;
  mjtStereo = Int32;
  mjtPluginCapabilityBit = Int32;
  mjtGridPos = Int32;
  mjtFramebuffer = Int32;
  mjtDepthMap = Int32;
  mjtFontScale = Int32;
  mjtFont = Int32;
  mjrPixelFormat = Int32;
  mjrVertexAttributeUsage = Int32;
  mjrVertexAttributeType = Int32;
  mjrIndexType = Int32;
  mjrMeshPrimitiveType = Int32;
  mjtButton = Int32;
  mjtEvent = Int32;
  mjtItem = Int32;
  mjtSection = Int32;

  //---------------------------------------------------------------------------
  // opaque types (only ever used through pointers)


  mjBatch = record end;

  //---------------------------------------------------------------------------
  // pointer types

  PmjLogMessage = ^mjLogMessage;
  PmjLogConfig = ^mjLogConfig;
  PmjLROpt = ^mjLROpt;
  PmjCache = ^mjCache;
  PmjVFS = ^mjVFS;
  PmjOption = ^mjOption;
  PmjVisual = ^mjVisual;
  PmjVisual_global = ^mjVisual_global;
  PmjVisual_quality = ^mjVisual_quality;
  PmjVisual_headlight = ^mjVisual_headlight;
  PmjVisual_map = ^mjVisual_map;
  PmjVisual_scale = ^mjVisual_scale;
  PmjVisual_rgba = ^mjVisual_rgba;
  PmjStatistic = ^mjStatistic;
  PmjModel = ^mjModel;
  PmjtNum = ^mjtNum;
  PmjInt32 = ^Int32;
  PmjtByte = ^mjtByte;
  PmjtBool = ^mjtBool;
  PmjSingle = ^Single;
  PmjtSize = ^mjtSize;
  PmjPreContact = ^mjPreContact;
  PmjContact = ^mjContact;
  PmjWarningStat = ^mjWarningStat;
  PmjTimerStat = ^mjTimerStat;
  PmjSolverStat = ^mjSolverStat;
  PmjData = ^mjData;
  PmjNativeUInt = ^NativeUInt;
  PmjsElement = ^mjsElement;
  PmjsCompiler = ^mjsCompiler;
  PmjsAuthored = ^mjsAuthored;
  PmjSpec = ^mjSpec;
  PmjsOrientation = ^mjsOrientation;
  PmjsPlugin = ^mjsPlugin;
  PmjsBody = ^mjsBody;
  PmjsFrame = ^mjsFrame;
  PmjsJoint = ^mjsJoint;
  PmjsGeom = ^mjsGeom;
  PmjsSite = ^mjsSite;
  PmjsCamera = ^mjsCamera;
  PmjsLight = ^mjsLight;
  PmjsFlex = ^mjsFlex;
  PmjsMesh = ^mjsMesh;
  PmjsHField = ^mjsHField;
  PmjsSkin = ^mjsSkin;
  PmjsTexture = ^mjsTexture;
  PmjsMaterial = ^mjsMaterial;
  PmjsPair = ^mjsPair;
  PmjsExclude = ^mjsExclude;
  PmjsEquality = ^mjsEquality;
  PmjsTendon = ^mjsTendon;
  PmjsWrap = ^mjsWrap;
  PmjsActuator = ^mjsActuator;
  PmjsSensor = ^mjsSensor;
  PmjsNumeric = ^mjsNumeric;
  PmjsText = ^mjsText;
  PmjsTuple = ^mjsTuple;
  PmjsKey = ^mjsKey;
  PmjsDefault = ^mjsDefault;
  PmjvPerturb = ^mjvPerturb;
  PmjvCamera = ^mjvCamera;
  PmjvGLCamera = ^mjvGLCamera;
  PmjvGeom = ^mjvGeom;
  PmjvLight = ^mjvLight;
  PmjvOption = ^mjvOption;
  PmjvScene = ^mjvScene;
  PmjvFigure = ^mjvFigure;
  PmjSDF = ^mjSDF;
  PmjtGeom = ^mjtGeom;
  PmjrRect = ^mjrRect;
  PmjrRendererInfo = ^mjrRendererInfo;
  PmjrVertexAttribute = ^mjrVertexAttribute;
  PmjrContext = ^mjrContext;
  PmjUInt32 = ^UInt32;
  PPmjtByte = ^PmjtByte;
  PmjDouble = ^Double;
  PPmjtNum = ^PmjtNum;
  PPmjInt32 = ^PmjInt32;
  PPmjsBody = ^PmjsBody;
  PPmjModel = ^PmjModel;
  PmjResource = ^mjResource;
  PPmjResource = ^PmjResource;
  PmjpResourceProvider = ^mjpResourceProvider;
  PmjpDecoder = ^mjpDecoder;
  PmjpEncoder = ^mjpEncoder;
  PmjpPlugin = ^mjpPlugin;
  PPmjpPlugin = ^PmjpPlugin;
  PmjBatch = ^mjBatch;
  PmjBatchConfig = ^mjBatchConfig;
  PmjBatchRecord = ^mjBatchRecord;

  //---------------------------------------------------------------------------
  // callback types (mjdata.h, mjtype.h, mjplugin.h, mjbatch.h)

  // generic MuJoCo function
  mjfGeneric = procedure(m: PmjModel; d: PmjData); cdecl;
  // contact filter: 1- discard, 0- collide
  mjfConFilt = function(m: PmjModel; d: PmjData; geom1, geom2: Int32): Int32; cdecl;
  // sensor simulation
  mjfSensor = procedure(m: PmjModel; d: PmjData; stage: Int32); cdecl;
  // timer
  mjfTime = function: mjtNum; cdecl;
  // actuator dynamics, gain, bias
  mjfAct = function(m: PmjModel; d: PmjData; id: Int32): mjtNum; cdecl;
  // collision detection
  mjfCollision = function(m: PmjModel; d: PmjData; con: PmjPreContact; g1, g2: Int32;
    margin: mjtNum): Int32; cdecl;
  // log handler; must be thread-safe, must not call mju_error
  mjfLogHandler = procedure(msg: PmjLogMessage); cdecl;
  // user-interface item enable test (the mjui_* API itself is not translated)
  mjfItemEnable = function(category: Int32; data: Pointer): Int32; cdecl;
  // cleanup for mjs_setUserValueWithCleanup
  mjfCleanup = procedure(data: Pointer); cdecl;

  // resource provider callbacks
  mjfOpenResource = function(resource: PmjResource): Int32; cdecl;
  mjfReadResource = function(resource: PmjResource; buffer: PPointer): Int32; cdecl;
  mjfCloseResource = procedure(resource: PmjResource); cdecl;
  mjfMountResource = function(resource: PmjResource): Int32; cdecl;
  mjfUnmountResource = function(resource: PmjResource): Int32; cdecl;
  mjfResourceModified = function(resource: PmjResource; timestamp: PAnsiChar): Int32; cdecl;
  mjfWriteResource = function(resource: PmjResource; buffer: Pointer; nbytes: mjtSize): mjtSize; cdecl;

  // decoder / encoder plugin callbacks
  mjfDecode = function(resource: PmjResource; vfs: PmjVFS; error: PAnsiChar;
    error_sz: Int32): PmjSpec; cdecl;
  mjfCanDecode = function(resource: PmjResource): Int32; cdecl;
  mjfEncode = function(s: PmjSpec; m: PmjModel; vfs: PmjVFS; resource: PmjResource): mjtSize; cdecl;

  // mj_loadAllPluginLibraries callback
  mjfPluginLibraryLoadCallback = procedure(filename: PAnsiChar; first, count: Int32); cdecl;

  // function run on one simulation by mjb_apply
  mjfBatchFunc = procedure(m: PmjModel; d: PmjData; sim: Int32; arg: Pointer); cdecl;

  // mjpPlugin members
  mjpPlugin_nstate = function(m: PmjModel; instance: Int32): Int32; cdecl;
  mjpPlugin_nsensordata = function(m: PmjModel; instance, sensor_id: Int32): Int32; cdecl;
  mjpPlugin_init = function(m: PmjModel; d: PmjData; instance: Int32): Int32; cdecl;
  mjpPlugin_destroy = procedure(d: PmjData; instance: Int32); cdecl;
  mjpPlugin_copy = procedure(dest: PmjData; m: PmjModel; src: PmjData; instance: Int32); cdecl;
  mjpPlugin_reset = procedure(m: PmjModel; plugin_state: PmjtNum; plugin_data: Pointer;
    instance: Int32); cdecl;
  mjpPlugin_compute = procedure(m: PmjModel; d: PmjData; instance, capability_bit: Int32); cdecl;
  mjpPlugin_advance = procedure(m: PmjModel; d: PmjData; instance: Int32); cdecl;
  mjpPlugin_visualize = procedure(m: PmjModel; d: PmjData; opt: PmjvOption; scn: PmjvScene;
    instance: Int32); cdecl;
  mjpPlugin_actuator_act_dot = procedure(m: PmjModel; d: PmjData; instance: Int32); cdecl;
  mjpPlugin_sdf_distance = function(point: PmjtNum; d: PmjData; instance: Int32): mjtNum; cdecl;
  mjpPlugin_sdf_gradient = procedure(gradient, point: PmjtNum; d: PmjData; instance: Int32); cdecl;
  mjpPlugin_sdf_staticdistance = function(point, attributes: PmjtNum): mjtNum; cdecl;
  mjpPlugin_sdf_attribute = procedure(attribute: PmjtNum; name, value: PPAnsiChar); cdecl;
  mjpPlugin_sdf_aabb = procedure(aabb, attributes: PmjtNum); cdecl;

  //---------------------------------------------------------------------------
  // records

  mjLogMessage = record
    level: Int32;                                // mjtLogLevel
    topic: Int32;                                // mjtLogTopic (0 for error/warning/user)
    subject: array[0..1023] of AnsiChar;         // message subject (one-liner, printf-formatted)
    body: PAnsiChar;                             // message body (multi-line detail, or NULL)
    func: PAnsiChar;                             // __func__ or NULL
    &file: PAnsiChar;                            // __FILE__ or NULL
    line: Int32;                                 // __LINE__ or 0
    timestamp: mjtBool;                          // prepend timestamp to output
  end;

  mjLogConfig = record
    logto_console: mjtBool;                      // print to console (default: true)
    logto_file: mjtBool;                         // print to log file (default: true)
    logfile: array[0..1023] of AnsiChar;         // log file path (default: "MUJOCO_LOG.TXT")
    topics: Int32;                               // enabled info topic bitmask (default: 0)
  end;

  mjLROpt = record
    mode: Int32;                                 // which actuators to process (mjtLRMode)
    useexisting: Int32;                          // use existing length range if available
    uselimit: Int32;                             // use joint and tendon limits if available
    accel: mjtNum;                               // target acceleration used to compute force
    maxforce: mjtNum;                            // maximum force; 0: no limit
    timeconst: mjtNum;                           // time constant for velocity reduction; min 0.01
    timestep: mjtNum;                            // simulation timestep; 0: use mjOption.timestep
    inttotal: mjtNum;                            // total simulation time interval
    interval: mjtNum;                            // evaluation time interval (at the end)
    tolrange: mjtNum;                            // convergence tolerance (relative to range)
  end;

  mjCache = record
    impl_: Pointer;                              // internal pointer to cache
  end;

  mjVFS = record
    impl_: Pointer;                              // internal pointer to VFS memory
  end;

  mjOption = record
    timestep: mjtNum;                            // timestep
    impratio: mjtNum;                            // ratio of friction-to-normal contact impedance
    tolerance: mjtNum;                           // main solver tolerance
    ls_tolerance: mjtNum;                        // CG/Newton linesearch tolerance
    noslip_tolerance: mjtNum;                    // noslip solver tolerance
    ccd_tolerance: mjtNum;                       // convex collision solver tolerance
    sleep_tolerance: mjtNum;                     // sleep velocity tolerance
    gravity: array[0..2] of mjtNum;              // gravitational acceleration
    wind: array[0..2] of mjtNum;                 // wind (for lift, drag and viscosity)
    magnetic: array[0..2] of mjtNum;             // global magnetic flux
    density: mjtNum;                             // density of medium
    viscosity: mjtNum;                           // viscosity of medium
    o_margin: mjtNum;                            // margin
    o_solref: array[0..1] of mjtNum;             // solref
    o_solimp: array[0..4] of mjtNum;             // solimp
    o_friction: array[0..4] of mjtNum;           // friction
    integrator: Int32;                           // integration mode (mjtIntegrator)
    cone: Int32;                                 // type of friction cone (mjtCone)
    jacobian: Int32;                             // type of Jacobian (mjtJacobian)
    solver: Int32;                               // solver algorithm (mjtSolver)
    iterations: Int32;                           // maximum number of main solver iterations
    ls_iterations: Int32;                        // maximum number of CG/Newton linesearch iterations
    noslip_iterations: Int32;                    // maximum number of noslip solver iterations
    ccd_iterations: Int32;                       // maximum number of convex collision solver iterations
    disableflags: Int32;                         // bit flags for disabling standard features
    enableflags: Int32;                          // bit flags for enabling optional features
    disableactuator: Int32;                      // bit flags for disabling actuators by group id
    sdf_initpoints: Int32;                       // number of starting points for gradient descent
    sdf_iterations: Int32;                       // max number of iterations for gradient descent
  end;

  mjVisual_global = record
    cameraid: Int32;                             // initial camera id (-1: free)
    orthographic: Int32;                         // is the free camera orthographic (0: no, 1: yes)
    fovy: Single;                                // y field-of-view of free camera (orthographic ? length : degree)
    ipd: Single;                                 // inter-pupilary distance for free camera
    azimuth: Single;                             // initial azimuth of free camera (degrees)
    elevation: Single;                           // initial elevation of free camera (degrees)
    linewidth: Single;                           // line width for wireframe and ray rendering
    glow: Single;                                // glow coefficient for selected body
    realtime: Single;                            // initial real-time factor (1: real time)
    offwidth: Int32;                             // width of offscreen buffer
    offheight: Int32;                            // height of offscreen buffer
    ellipsoidinertia: Int32;                     // geom for inertia visualization (0: box, 1: ellipsoid)
    bvactive: Int32;                             // visualize active bounding volumes (0: no, 1: yes)
  end;

  mjVisual_quality = record
    shadowsize: Int32;                           // size of shadowmap texture
    offsamples: Int32;                           // number of multisamples for offscreen rendering
    numslices: Int32;                            // number of slices for builtin geom drawing
    numstacks: Int32;                            // number of stacks for builtin geom drawing
    numquads: Int32;                             // number of quads for box rendering
  end;

  mjVisual_headlight = record
    ambient: array[0..2] of Single;              // ambient rgb (alpha=1)
    diffuse: array[0..2] of Single;              // diffuse rgb (alpha=1)
    specular: array[0..2] of Single;             // specular rgb (alpha=1)
    active: Int32;                               // is headlight active
  end;

  mjVisual_map = record
    stiffness: Single;                           // mouse perturbation stiffness (space->force)
    stiffnessrot: Single;                        // mouse perturbation stiffness (space->torque)
    force: Single;                               // from force units to space units
    torque: Single;                              // from torque units to space units
    alpha: Single;                               // scale geom alphas when transparency is enabled
    fogstart: Single;                            // OpenGL fog starts at fogstart * mjModel.stat.extent
    fogend: Single;                              // OpenGL fog ends at fogend * mjModel.stat.extent
    znear: Single;                               // near clipping plane = znear * mjModel.stat.extent
    zfar: Single;                                // far clipping plane = zfar * mjModel.stat.extent
    haze: Single;                                // haze ratio
    shadowclip: Single;                          // directional light: shadowclip * mjModel.stat.extent
    shadowscale: Single;                         // spot light: shadowscale * light.cutoff
    actuatortendon: Single;                      // scale tendon width
  end;

  mjVisual_scale = record
    forcewidth: Single;                          // width of force arrow
    contactwidth: Single;                        // contact width
    contactheight: Single;                       // contact height
    connect: Single;                             // autoconnect capsule width
    com: Single;                                 // com radius
    camera: Single;                              // camera object
    light: Single;                               // light object
    selectpoint: Single;                         // selection point
    jointlength: Single;                         // joint length
    jointwidth: Single;                          // joint width
    actuatorlength: Single;                      // actuator length
    actuatorwidth: Single;                       // actuator width
    framelength: Single;                         // bodyframe axis length
    framewidth: Single;                          // bodyframe axis width
    constraint: Single;                          // constraint width
    slidercrank: Single;                         // slidercrank width
    frustum: Single;                             // frustum zfar plane
  end;

  mjVisual_rgba = record
    fog: array[0..3] of Single;                  // fog
    haze: array[0..3] of Single;                 // haze
    force: array[0..3] of Single;                // external force
    inertia: array[0..3] of Single;              // inertia box
    joint: array[0..3] of Single;                // joint
    actuator: array[0..3] of Single;             // actuator, neutral
    actuatornegative: array[0..3] of Single;     // actuator, negative limit
    actuatorpositive: array[0..3] of Single;     // actuator, positive limit
    com: array[0..3] of Single;                  // center of mass
    camera: array[0..3] of Single;               // camera object
    light: array[0..3] of Single;                // light object
    selectpoint: array[0..3] of Single;          // selection point
    connect: array[0..3] of Single;              // auto connect
    contactpoint: array[0..3] of Single;         // contact point
    contactforce: array[0..3] of Single;         // contact force
    contactfriction: array[0..3] of Single;      // contact friction force
    contacttorque: array[0..3] of Single;        // contact torque
    contactgap: array[0..3] of Single;           // contact point in gap
    rangefinder: array[0..3] of Single;          // rangefinder ray
    constraint: array[0..3] of Single;           // constraint
    slidercrank: array[0..3] of Single;          // slidercrank
    crankbroken: array[0..3] of Single;          // used when crank must be stretched/broken
    frustum: array[0..3] of Single;              // camera frustum
    bv: array[0..3] of Single;                   // bounding volume
    bvactive: array[0..3] of Single;             // active bounding volume
  end;

  mjVisual = record
    global: mjVisual_global;
    quality: mjVisual_quality;
    headlight: mjVisual_headlight;
    map: mjVisual_map;
    scale: mjVisual_scale;
    rgba: mjVisual_rgba;
  end;

  mjStatistic = record
    meaninertia: mjtNum;                         // mean diagonal inertia
    meanmass: mjtNum;                            // mean body mass
    meansize: mjtNum;                            // mean body size
    extent: mjtNum;                              // spatial extent
    center: array[0..2] of mjtNum;               // center of model
  end;

  mjModel = record
    nq: mjtSize;                                 // number of generalized coordinates = dim(qpos)
    nv: mjtSize;                                 // number of degrees of freedom = dim(qvel)
    nu: mjtSize;                                 // number of scalar controls = dim(ctrl)
    nactuator: mjtSize;                          // number of actuators
    nout: mjtSize;                               // number of force outputs, derived from transmission type
    na: mjtSize;                                 // number of activation states = dim(act)
    nbody: mjtSize;                              // number of bodies
    nbvh: mjtSize;                               // number of total bounding volumes in all bodies
    nbvhstatic: mjtSize;                         // number of static bounding volumes (aabb stored in mjModel)
    nbvhdynamic: mjtSize;                        // number of dynamic bounding volumes (aabb stored in mjData)
    noct: mjtSize;                               // number of total octree cells in all meshes
    njnt: mjtSize;                               // number of joints
    ntree: mjtSize;                              // number of kinematic trees under world body
    nM: mjtSize;                                 // number of non-zeros in sparse inertia matrix
    nB: mjtSize;                                 // number of non-zeros in sparse body-dof matrix
    nC: mjtSize;                                 // number of non-zeros in sparse reduced dof-dof matrix
    nD: mjtSize;                                 // number of non-zeros in sparse dof-dof matrix
    ngeom: mjtSize;                              // number of geoms
    nsite: mjtSize;                              // number of sites
    ncam: mjtSize;                               // number of cameras
    nlight: mjtSize;                             // number of lights
    nflex: mjtSize;                              // number of flexes
    nflexnode: mjtSize;                          // number of dofs in all flexes
    nflexvert: mjtSize;                          // number of vertices in all flexes
    nflexedge: mjtSize;                          // number of edges in all flexes
    nflexelem: mjtSize;                          // number of elements in all flexes
    nflexelemdata: mjtSize;                      // number of element vertex ids in all flexes
    nflexstiffness: mjtSize;                     // number of stiffness parameters in all flexes
    nflexbending: mjtSize;                       // number of bending parameters in all flexes
    nefm0dof: mjtSize;                           // number of dofs covered by the constant metric factor
    nefm0L: mjtSize;                             // number of non-zeros in the constant metric factor
    nefmCvert: mjtSize;                          // number of sparse metric factor ordering slots
    nflexelemedge: mjtSize;                      // number of element edge ids in all flexes
    nflexshelldata: mjtSize;                     // number of shell fragment vertex ids in all flexes
    nflextexcoord: mjtSize;                      // number of vertices with texture coordinates
    nJfe: mjtSize;                               // number of non-zeros in sparse flexedge Jacobian matrix
    nJfv: mjtSize;                               // number of non-zeros in sparse flexvert Jacobian matrix
    nmesh: mjtSize;                              // number of meshes
    nmeshvert: mjtSize;                          // number of vertices in all meshes
    nmeshnormal: mjtSize;                        // number of normals in all meshes
    nmeshtexcoord: mjtSize;                      // number of texcoords in all meshes
    nmeshface: mjtSize;                          // number of triangular faces in all meshes
    nmeshgraph: mjtSize;                         // number of ints in mesh auxiliary data
    nmeshpoly: mjtSize;                          // number of polygons in all meshes
    nmeshpolyvert: mjtSize;                      // number of vertices in all polygons
    nmeshpolymap: mjtSize;                       // number of polygons in vertex map
    nskin: mjtSize;                              // number of skins
    nskinvert: mjtSize;                          // number of vertices in all skins
    nskintexvert: mjtSize;                       // number of vertices with texcoords in all skins
    nskinface: mjtSize;                          // number of triangular faces in all skins
    nskinbone: mjtSize;                          // number of bones in all skins
    nskinbonevert: mjtSize;                      // number of vertices in all skin bones
    nhfield: mjtSize;                            // number of heightfields
    nhfielddata: mjtSize;                        // number of data points in all heightfields
    ntex: mjtSize;                               // number of textures
    ntexdata: mjtSize;                           // number of bytes in texture rgb data
    nmat: mjtSize;                               // number of materials
    npair: mjtSize;                              // number of predefined geom pairs
    nexclude: mjtSize;                           // number of excluded geom pairs
    neq: mjtSize;                                // number of equality constraints
    ntendon: mjtSize;                            // number of tendons
    nJten: mjtSize;                              // number of non-zeros in sparse ten_J matrix
    nwrap: mjtSize;                              // number of wrap objects in all tendon paths
    nsensor: mjtSize;                            // number of sensors
    nnumeric: mjtSize;                           // number of numeric custom fields
    nnumericdata: mjtSize;                       // number of mjtNums in all numeric fields
    ntext: mjtSize;                              // number of text custom fields
    ntextdata: mjtSize;                          // number of mjtBytes in all text fields
    ntuple: mjtSize;                             // number of tuple custom fields
    ntupledata: mjtSize;                         // number of objects in all tuple fields
    nkey: mjtSize;                               // number of keyframes
    nmocap: mjtSize;                             // number of mocap bodies
    nplugin: mjtSize;                            // number of plugin instances
    npluginattr: mjtSize;                        // number of chars in all plugin config attributes
    nuser_body: mjtSize;                         // number of mjtNums in body_user
    nuser_jnt: mjtSize;                          // number of mjtNums in jnt_user
    nuser_geom: mjtSize;                         // number of mjtNums in geom_user
    nuser_site: mjtSize;                         // number of mjtNums in site_user
    nuser_cam: mjtSize;                          // number of mjtNums in cam_user
    nuser_tendon: mjtSize;                       // number of mjtNums in tendon_user
    nuser_actuator: mjtSize;                     // number of mjtNums in actuator_user
    nuser_sensor: mjtSize;                       // number of mjtNums in sensor_user
    nnames: mjtSize;                             // number of chars in all names
    npaths: mjtSize;                             // number of chars in all paths
    nnames_map: mjtSize;                         // number of slots in the names hash map
    nJmom: mjtSize;                              // number of non-zeros in sparse actuator_moment matrix
    ngravcomp: mjtSize;                          // number of bodies with nonzero gravcomp
    nemax: mjtSize;                              // number of potential equality-constraint rows
    njmax: mjtSize;                              // number of available rows in constraint Jacobian (legacy)
    nconmax: mjtSize;                            // number of potential contacts in contact list (legacy)
    npolygonmax: mjtSize;                        // maximum number of vertices in a mesh polygon
    nmeshdegmax: mjtSize;                        // maximum number of edges adjacent to a mesh vertex
    nuserdata: mjtSize;                          // number of mjtNums reserved for the user
    nsensordata: mjtSize;                        // number of mjtNums in sensor data vector
    npluginstate: mjtSize;                       // number of mjtNums in plugin state vector
    nhistory: mjtSize;                           // number of mjtNums in history buffer
    narena: mjtSize;                             // number of bytes in the mjData arena (inclusive of stack)
    nbuffer: mjtSize;                            // number of bytes in buffer
    flg_gravcomp: mjtBool;                       // whether any body has nonzero gravcomp
    flg_surfacevel: mjtBool;                     // whether any geom has nonzero surfacevel
    flg_adhesion: mjtBool;                       // whether any geom or pair has nonzero adhesion
    opt: mjOption;                               // physics options
    vis: mjVisual;                               // visualization options
    stat: mjStatistic;                           // model statistics
    buffer: Pointer;                             // main buffer; all pointers point in it (nbuffer)
    qpos0: PmjtNum;                              // qpos values at default pose
    qpos_spring: PmjtNum;                        // reference pose for springs
    body_parentid: PmjInt32;                     // id of body's parent
    body_rootid: PmjInt32;                       // ancestor that is direct child of world
    body_weldid: PmjInt32;                       // top dof-less ancestor; mocap: own root
    body_mocapid: PmjInt32;                      // id of mocap data; -1: none
    body_jntnum: PmjInt32;                       // number of joints for this body
    body_jntadr: PmjInt32;                       // start addr of joints; -1: no joints
    body_dofnum: PmjInt32;                       // number of motion degrees of freedom
    body_dofadr: PmjInt32;                       // start addr of dofs; -1: no dofs
    body_treeid: PmjInt32;                       // id of body's kinematic tree; -1: static
    body_geomnum: PmjInt32;                      // number of geoms
    body_geomadr: PmjInt32;                      // start addr of geoms; -1: no geoms
    body_simple: PmjtByte;                       // 1: diag M; 2: diag M, sliders only
    body_sameframe: PmjtByte;                    // same frame as inertia (mjtSameframe)
    body_pos: PmjtNum;                           // position offset rel. to parent body
    body_quat: PmjtNum;                          // orientation offset rel. to parent body
    body_ipos: PmjtNum;                          // local position of center of mass
    body_iquat: PmjtNum;                         // local orientation of inertia ellipsoid
    body_mass: PmjtNum;                          // mass
    body_subtreemass: PmjtNum;                   // mass of subtree starting at this body
    body_inertia: PmjtNum;                       // diagonal inertia in ipos/iquat frame
    body_invweight0: PmjtNum;                    // mean inv inert in qpos0 (trn, rot)
    body_gravcomp: PmjtNum;                      // antigravity force, units of body weight
    body_margin: PmjtNum;                        // MAX over all geom margins+gaps
    body_user: PmjtNum;                          // user data
    body_plugin: PmjInt32;                       // plugin instance id; -1: not in use
    body_contype: PmjInt32;                      // OR over all geom contypes
    body_conaffinity: PmjInt32;                  // OR over all geom conaffinities
    body_bvhadr: PmjInt32;                       // address of bvh root
    body_bvhnum: PmjInt32;                       // number of bounding volumes
    bvh_depth: PmjInt32;                         // depth in the bounding volume hierarchy
    bvh_child: PmjInt32;                         // left and right children in tree
    bvh_nodeid: PmjInt32;                        // geom or elem id of node; -1: non-leaf
    bvh_aabb: PmjtNum;                           // local bounding box (center, size)
    oct_depth: PmjInt32;                         // depth in the octree
    oct_child: PmjInt32;                         // children of octree node
    oct_aabb: PmjtNum;                           // octree node bounding box (center, size)
    oct_coeff: PmjtNum;                          // octree interpolation coefficients
    jnt_type: PmjInt32;                          // type of joint (mjtJoint)
    jnt_qposadr: PmjInt32;                       // start addr in 'qpos' for joint's data
    jnt_dofadr: PmjInt32;                        // start addr in 'qvel' for joint's data
    jnt_bodyid: PmjInt32;                        // id of joint's body
    jnt_actuatorid: PmjInt32;                    // actuator contributing damping / armature
    jnt_group: PmjInt32;                         // group for visibility
    jnt_limited: PmjtBool;                       // does joint have limits
    jnt_actfrclimited: PmjtBool;                 // does joint have actuator force limits
    jnt_actgravcomp: PmjtBool;                   // is gravcomp force applied via actuators
    jnt_solref: PmjtNum;                         // constraint solver reference: limit
    jnt_solimp: PmjtNum;                         // constraint solver impedance: limit
    jnt_pos: PmjtNum;                            // local anchor position
    jnt_axis: PmjtNum;                           // local joint axis
    jnt_stiffness: PmjtNum;                      // linear stiffness coefficient
    jnt_stiffnesspoly: PmjtNum;                  // high-order stiffness coefficients
    jnt_range: PmjtNum;                          // joint limits
    jnt_actfrcrange: PmjtNum;                    // range of total actuator force
    jnt_margin: PmjtNum;                         // min distance for limit detection
    jnt_user: PmjtNum;                           // user data
    dof_bodyid: PmjInt32;                        // id of dof's body
    dof_jntid: PmjInt32;                         // id of dof's joint
    dof_parentid: PmjInt32;                      // id of dof's parent; -1: none
    dof_treeid: PmjInt32;                        // id of dof's kinematic tree
    dof_Madr: PmjInt32;                          // dof address in M-diagonal
    dof_simplenum: PmjInt32;                     // number of consecutive simple dofs
    dof_solref: PmjtNum;                         // constraint solver reference:frictionloss
    dof_solimp: PmjtNum;                         // constraint solver impedance:frictionloss
    dof_frictionloss: PmjtNum;                   // dof friction loss
    dof_armature: PmjtNum;                       // dof armature inertia/mass
    dof_damping: PmjtNum;                        // linear damping coefficient
    dof_dampingpoly: PmjtNum;                    // high-order damping coefficients
    dof_invweight0: PmjtNum;                     // diag. inverse inertia in qpos0
    dof_M0: PmjtNum;                             // diag. inertia in qpos0
    dof_length: PmjtNum;                         // linear: 1; angular: approx. length scale
    tree_bodyadr: PmjInt32;                      // start addr of bodies
    tree_bodynum: PmjInt32;                      // number of bodies in tree
    tree_dofadr: PmjInt32;                       // start addr of dofs
    tree_dofnum: PmjInt32;                       // number of dofs in tree
    tree_sleep_policy: PmjInt32;                 // sleep policy (mjtSleepPolicy)
    geom_type: PmjInt32;                         // geometric type (mjtGeom)
    geom_contype: PmjInt32;                      // geom contact type
    geom_conaffinity: PmjInt32;                  // geom contact affinity
    geom_condim: PmjInt32;                       // contact dimensionality (1, 3, 4, 6)
    geom_bodyid: PmjInt32;                       // id of geom's body
    geom_dataid: PmjInt32;                       // id of geom's mesh/hfield; -1: none
    geom_matid: PmjInt32;                        // material id for rendering; -1: none
    geom_group: PmjInt32;                        // group for visibility
    geom_priority: PmjInt32;                     // geom contact priority
    geom_plugin: PmjInt32;                       // plugin instance id; -1: not in use
    geom_sameframe: PmjtByte;                    // same frame as body (mjtSameframe)
    geom_solmix: PmjtNum;                        // mixing coef for solref/imp in geom pair
    geom_solref: PmjtNum;                        // constraint solver reference: contact
    geom_solimp: PmjtNum;                        // constraint solver impedance: contact
    geom_size: PmjtNum;                          // geom-specific size parameters
    geom_aabb: PmjtNum;                          // bounding box, (center, size)
    geom_rbound: PmjtNum;                        // radius of bounding sphere
    geom_pos: PmjtNum;                           // local position offset rel. to body
    geom_quat: PmjtNum;                          // local orientation offset rel. to body
    geom_friction: PmjtNum;                      // friction for (slide, spin, roll)
    geom_margin: PmjtNum;                        // geometric inflation for contact
    geom_gap: PmjtNum;                           // additional contact detection buffer
    geom_surfacevel: PmjtNum;                    // surface velocity in local frame: lin,ang
    geom_adhesion: PmjtNum;                      // adhesive force of contacts
    geom_fluid: PmjtNum;                         // fluid interaction parameters
    geom_user: PmjtNum;                          // user data
    geom_rgba: PmjSingle;                        // rgba when material is omitted
    site_type: PmjInt32;                         // geom type for rendering (mjtGeom)
    site_bodyid: PmjInt32;                       // id of site's body
    site_dataid: PmjInt32;                       // id of site's mesh; -1: none
    site_matid: PmjInt32;                        // material id for rendering; -1: none
    site_group: PmjInt32;                        // group for visibility
    site_sameframe: PmjtByte;                    // same frame as body (mjtSameframe)
    site_size: PmjtNum;                          // geom size for rendering
    site_pos: PmjtNum;                           // local position offset rel. to body
    site_quat: PmjtNum;                          // local orientation offset rel. to body
    site_user: PmjtNum;                          // user data
    site_rgba: PmjSingle;                        // rgba when material is omitted
    cam_mode: PmjInt32;                          // camera tracking mode (mjtCamLight)
    cam_bodyid: PmjInt32;                        // id of camera's body
    cam_targetbodyid: PmjInt32;                  // id of targeted body; -1: none
    cam_pos: PmjtNum;                            // position rel. to body frame
    cam_quat: PmjtNum;                           // orientation rel. to body frame
    cam_poscom0: PmjtNum;                        // global position rel. to sub-com in qpos0
    cam_pos0: PmjtNum;                           // global position rel. to body in qpos0
    cam_mat0: PmjtNum;                           // global orientation in qpos0
    cam_projection: PmjInt32;                    // projection type (mjtProjection)
    cam_fovy: PmjtNum;                           // y field-of-view (ortho ? len : deg)
    cam_ipd: PmjtNum;                            // inter-pupilary distance
    cam_resolution: PmjInt32;                    // resolution: pixels [width, height]
    cam_output: PmjInt32;                        // output types (mjtCamOut bit flags)
    cam_sensorsize: PmjSingle;                   // sensor size: length [width, height]
    cam_intrinsic: PmjSingle;                    // [focal length; principal point]
    cam_user: PmjtNum;                           // user data
    light_mode: PmjInt32;                        // light tracking mode (mjtCamLight)
    light_bodyid: PmjInt32;                      // id of light's body
    light_targetbodyid: PmjInt32;                // id of targeted body; -1: none
    light_type: PmjInt32;                        // spot, directional, etc. (mjtLightType)
    light_texid: PmjInt32;                       // texture id for image lights
    light_castshadow: PmjtBool;                  // does light cast shadows
    light_bulbradius: PmjSingle;                 // light radius for soft shadows
    light_intensity: PmjSingle;                  // intensity, in candela
    light_range: PmjSingle;                      // range of effectiveness
    light_active: PmjtBool;                      // is light on
    light_pos: PmjtNum;                          // position rel. to body frame
    light_dir: PmjtNum;                          // direction rel. to body frame
    light_poscom0: PmjtNum;                      // global position rel. to sub-com in qpos0
    light_pos0: PmjtNum;                         // global position rel. to body in qpos0
    light_dir0: PmjtNum;                         // global direction in qpos0
    light_attenuation: PmjSingle;                // OpenGL attenuation (quadratic model)
    light_cutoff: PmjSingle;                     // OpenGL cutoff
    light_softness: PmjSingle;                   // spotlight edge softness
    light_exponent: PmjSingle;                   // OpenGL exponent
    light_ambient: PmjSingle;                    // ambient rgb (alpha=1)
    light_diffuse: PmjSingle;                    // diffuse rgb (alpha=1)
    light_specular: PmjSingle;                   // specular rgb (alpha=1)
    flex_contype: PmjInt32;                      // flex contact type
    flex_conaffinity: PmjInt32;                  // flex contact affinity
    flex_condim: PmjInt32;                       // contact dimensionality (1, 3, 4, 6)
    flex_priority: PmjInt32;                     // flex contact priority
    flex_solmix: PmjtNum;                        // mix coef for solref/imp in contact pair
    flex_solref: PmjtNum;                        // constraint solver reference: contact
    flex_solimp: PmjtNum;                        // constraint solver impedance: contact
    flex_friction: PmjtNum;                      // friction for (slide, spin, roll)
    flex_margin: PmjtNum;                        // geometric inflation for contact
    flex_gap: PmjtNum;                           // additional contact detection buffer
    flex_selfcollide: PmjInt32;                  // self collision mode (mjtFlexSelf)
    flex_activelayers: PmjInt32;                 // number of active element layers, 3D only
    flex_passive: PmjInt32;                      // passive collisions enabled
    flex_dim: PmjInt32;                          // 1: lines, 2: triangles, 3: tetrahedra
    flex_matid: PmjInt32;                        // material id for rendering
    flex_group: PmjInt32;                        // group for visibility
    flex_interp: PmjInt32;                       // interpolation (0: vertex, 1: nodes)
    flex_cellnum: PmjInt32;                      // finite cell num per dimension
    flex_nodeadr: PmjInt32;                      // first node address
    flex_nodenum: PmjInt32;                      // number of nodes
    flex_vertadr: PmjInt32;                      // first vertex address
    flex_vertnum: PmjInt32;                      // number of vertices
    flex_edgeadr: PmjInt32;                      // first edge address
    flex_edgenum: PmjInt32;                      // number of edges
    flex_elemadr: PmjInt32;                      // first element address
    flex_elemnum: PmjInt32;                      // number of elements
    flex_elemdataadr: PmjInt32;                  // first element vertex id address
    flex_stiffnessadr: PmjInt32;                 // stiffness matrix address
    flex_elemedgeadr: PmjInt32;                  // first element edge id address
    flex_bendingadr: PmjInt32;                   // first bending data address
    flex_shellnum: PmjInt32;                     // number of shells
    flex_shelldataadr: PmjInt32;                 // first shell data address
    flex_texcoordadr: PmjInt32;                  // address in flex_texcoord; -1: none
    flex_nodebodyid: PmjInt32;                   // node body ids
    flex_vertbodyid: PmjInt32;                   // vertex body ids
    flex_vertedgeadr: PmjInt32;                  // first edge address
    flex_vertedgenum: PmjInt32;                  // number of edges
    flex_vertedge: PmjInt32;                     // edge indices
    flex_edge: PmjInt32;                         // edge vertex ids (2 per edge)
    flex_edgeflap: PmjInt32;                     // adjacent vertex ids (dim=2 only)
    flex_elem: PmjInt32;                         // element vertex ids (dim+1 per elem)
    flex_elemtexcoord: PmjInt32;                 // element texture coordinates (dim+1)
    flex_elemedge: PmjInt32;                     // element edge ids
    flex_elemlayer: PmjInt32;                    // element distance from surface, 3D only
    flex_shell: PmjInt32;                        // shell fragment vertex ids (dim per frag)
    flex_vert: PmjtNum;                          // vertex positions in local body frames
    flex_vert0: PmjtNum;                         // vertex positions in qpos0 on [0, 1]^d
    flex_vertmetric: PmjtNum;                    // inverse of reference shape matrix
    flex_node: PmjtNum;                          // node positions in local body frames
    flex_node0: PmjtNum;                         // Cartesian node positions in qpos0
    flexedge_length0: PmjtNum;                   // edge lengths in qpos0
    flexedge_invweight0: PmjtNum;                // edge inv. weight in qpos0
    flex_radius: PmjtNum;                        // radius around primitive element
    flex_size: PmjtNum;                          // vertex bounding box half sizes in qpos0
    flex_stiffness: PmjtNum;                     // finite element stiffness matrix
    flex_bending: PmjtNum;                       // bending stiffness
    efm0_dofid: PmjInt32;                        // constant metric factor row->dof address
    efm0_L_rownnz: PmjInt32;                     // constant metric factor row nonzeros
    efm0_L_rowadr: PmjInt32;                     // constant metric factor row addresses
    efm0_L_colind: PmjInt32;                     // constant metric factor column indices
    efm0_L: PmjtNum;                             // factor of M + (dt^2+dt*d)*K_bend
    efmC_perm: PmjInt32;                         // sparse factor order: vertex dof or -1
    flex_damping: PmjtNum;                       // Rayleigh's damping coefficient
    flex_edgestiffness: PmjtNum;                 // edge stiffness
    flex_edgedamping: PmjtNum;                   // edge damping
    flex_edgeequality: PmjInt32;                 // 0:none, 1:edges, 2:vertices, 3:strain
    flex_rigid: PmjtBool;                        // are all vertices in the same body
    flexedge_rigid: PmjtBool;                    // are both edge vertices in same body
    flex_centered: PmjtBool;                     // are all vertex coordinates (0,0,0)
    flex_flatskin: PmjtBool;                     // render flex skin with flat shading
    flex_bvhadr: PmjInt32;                       // address of bvh root; -1: no bvh
    flex_bvhnum: PmjInt32;                       // number of bounding volumes
    flexedge_J_rownnz: PmjInt32;                 // number of non-zeros in Jacobian row
    flexedge_J_rowadr: PmjInt32;                 // row start address in colind array
    flexedge_J_colind: PmjInt32;                 // column indices in sparse Jacobian
    flexvert_J_rownnz: PmjInt32;                 // number of non-zeros in Jacobian row
    flexvert_J_rowadr: PmjInt32;                 // row start address in colind array
    flexvert_J_colind: PmjInt32;                 // column indices in sparse Jacobian
    flex_rgba: PmjSingle;                        // rgba when material is omitted
    flex_texcoord: PmjSingle;                    // vertex texture coordinates
    mesh_vertadr: PmjInt32;                      // first vertex address
    mesh_vertnum: PmjInt32;                      // number of vertices
    mesh_faceadr: PmjInt32;                      // first face address
    mesh_facenum: PmjInt32;                      // number of faces
    mesh_bvhadr: PmjInt32;                       // address of bvh root
    mesh_bvhnum: PmjInt32;                       // number of bvh
    mesh_octadr: PmjInt32;                       // address of octree root
    mesh_octnum: PmjInt32;                       // number of octree nodes
    mesh_normaladr: PmjInt32;                    // first normal address
    mesh_normalnum: PmjInt32;                    // number of normals
    mesh_texcoordadr: PmjInt32;                  // texcoord data address; -1: no texcoord
    mesh_texcoordnum: PmjInt32;                  // number of texcoord
    mesh_graphadr: PmjInt32;                     // graph data address; -1: no graph
    mesh_extrema: PmjInt32;                      // extremum vertices in 3x3x3 directions
    mesh_vert: PmjSingle;                        // vertex positions for all meshes
    mesh_normal: PmjSingle;                      // normals for all meshes
    mesh_texcoord: PmjSingle;                    // vertex texcoords for all meshes
    mesh_face: PmjInt32;                         // vertex face data
    mesh_facenormal: PmjInt32;                   // normal face data
    mesh_facetexcoord: PmjInt32;                 // texture face data
    mesh_graph: PmjInt32;                        // convex graph data
    mesh_scale: PmjtNum;                         // scaling applied to asset vertices
    mesh_pos: PmjtNum;                           // translation applied to asset vertices
    mesh_quat: PmjtNum;                          // rotation applied to asset vertices
    mesh_pathadr: PmjInt32;                      // address of asset path for mesh; -1: none
    mesh_polynum: PmjInt32;                      // number of polygons per mesh
    mesh_polyadr: PmjInt32;                      // first polygon address per mesh
    mesh_polynormal: PmjtNum;                    // all polygon normals
    mesh_polyvertadr: PmjInt32;                  // polygon vertex start address
    mesh_polyvertnum: PmjInt32;                  // number of vertices per polygon
    mesh_polyvert: PmjInt32;                     // all polygon vertices
    mesh_polymapadr: PmjInt32;                   // first polygon address per vertex
    mesh_polymapnum: PmjInt32;                   // number of polygons per vertex
    mesh_polymap: PmjInt32;                      // vertex to polygon map
    skin_matid: PmjInt32;                        // skin material id; -1: none
    skin_group: PmjInt32;                        // group for visibility
    skin_rgba: PmjSingle;                        // skin rgba
    skin_inflate: PmjSingle;                     // inflate skin in normal direction
    skin_vertadr: PmjInt32;                      // first vertex address
    skin_vertnum: PmjInt32;                      // number of vertices
    skin_texcoordadr: PmjInt32;                  // texcoord data address; -1: no texcoord
    skin_faceadr: PmjInt32;                      // first face address
    skin_facenum: PmjInt32;                      // number of faces
    skin_boneadr: PmjInt32;                      // first bone in skin
    skin_bonenum: PmjInt32;                      // number of bones in skin
    skin_vert: PmjSingle;                        // vertex positions for all skin meshes
    skin_texcoord: PmjSingle;                    // vertex texcoords for all skin meshes
    skin_face: PmjInt32;                         // triangle faces for all skin meshes
    skin_bonevertadr: PmjInt32;                  // first vertex in each bone
    skin_bonevertnum: PmjInt32;                  // number of vertices in each bone
    skin_bonebindpos: PmjSingle;                 // bind pos of each bone
    skin_bonebindquat: PmjSingle;                // bind quat of each bone
    skin_bonebodyid: PmjInt32;                   // body id of each bone
    skin_bonevertid: PmjInt32;                   // mesh ids of vertices in each bone
    skin_bonevertweight: PmjSingle;              // weights of vertices in each bone
    skin_pathadr: PmjInt32;                      // address of asset path for skin; -1: none
    hfield_size: PmjtNum;                        // (x, y, z_top, z_bottom)
    hfield_nrow: PmjInt32;                       // number of rows in grid
    hfield_ncol: PmjInt32;                       // number of columns in grid
    hfield_adr: PmjInt32;                        // address in hfield_data
    hfield_data: PmjSingle;                      // elevation data
    hfield_pathadr: PmjInt32;                    // address of hfield asset path; -1: none
    tex_type: PmjInt32;                          // texture type (mjtTexture)
    tex_colorspace: PmjInt32;                    // texture colorspace (mjtColorSpace)
    tex_height: PmjInt32;                        // number of rows in texture image
    tex_width: PmjInt32;                         // number of columns in texture image
    tex_nchannel: PmjInt32;                      // number of channels in texture image
    tex_adr: PmjtSize;                           // start address in tex_data
    tex_data: PmjtByte;                          // pixel values
    tex_pathadr: PmjInt32;                       // address of texture asset path; -1: none
    tex_contenttypeadr: PmjInt32;                // content type address in paths; -1: none
    mat_texid: PmjInt32;                         // indices of textures; -1: none
    mat_texuniform: PmjtBool;                    // make texture cube uniform
    mat_texrepeat: PmjSingle;                    // texture repetition for 2d mapping
    mat_emission: PmjSingle;                     // emission (x rgb)
    mat_specular: PmjSingle;                     // specular (x white)
    mat_shininess: PmjSingle;                    // shininess coef
    mat_reflectance: PmjSingle;                  // reflectance (0: disable)
    mat_metallic: PmjSingle;                     // metallic coef
    mat_roughness: PmjSingle;                    // roughness coef
    mat_rgba: PmjSingle;                         // rgba
    pair_dim: PmjInt32;                          // contact dimensionality
    pair_geom1: PmjInt32;                        // id of geom1
    pair_geom2: PmjInt32;                        // id of geom2
    pair_signature: PmjInt32;                    // body1 << 16 + body2
    pair_solref: PmjtNum;                        // solver reference: contact normal
    pair_solreffriction: PmjtNum;                // solver reference: contact friction
    pair_solimp: PmjtNum;                        // solver impedance: contact
    pair_margin: PmjtNum;                        // geometric inflation for contact
    pair_gap: PmjtNum;                           // additional contact detection buffer
    pair_adhesion: PmjtNum;                      // adhesive force of contacts
    pair_friction: PmjtNum;                      // tangent1, 2, spin, roll1, 2
    exclude_signature: PmjInt32;                 // body1 << 16 + body2
    eq_type: PmjInt32;                           // constraint type (mjtEq)
    eq_obj1id: PmjInt32;                         // id of object 1
    eq_obj2id: PmjInt32;                         // id of object 2
    eq_objtype: PmjInt32;                        // type of both objects (mjtObj)
    eq_active0: PmjtBool;                        // initial enable/disable constraint state
    eq_solref: PmjtNum;                          // constraint solver reference
    eq_solimp: PmjtNum;                          // constraint solver impedance
    eq_data: PmjtNum;                            // numeric data for constraint
    tendon_adr: PmjInt32;                        // address of first object in tendon's path
    tendon_num: PmjInt32;                        // number of objects in tendon's path
    tendon_matid: PmjInt32;                      // material id for rendering
    tendon_actuatorid: PmjInt32;                 // actuator contributing damping / armature
    tendon_group: PmjInt32;                      // group for visibility
    tendon_treenum: PmjInt32;                    // number of trees along tendon's path
    tendon_treeid: PmjInt32;                     // first two trees along tendon's path
    ten_J_rownnz: PmjInt32;                      // number of non-zeros in Jacobian row
    ten_J_rowadr: PmjInt32;                      // row start address in colind array
    ten_J_colind: PmjInt32;                      // column indices in sparse Jacobian
    tendon_limited: PmjtBool;                    // does tendon have length limits
    tendon_actfrclimited: PmjtBool;              // does tendon have actuator force limits
    tendon_width: PmjtNum;                       // width for rendering
    tendon_solref_lim: PmjtNum;                  // constraint solver reference: limit
    tendon_solimp_lim: PmjtNum;                  // constraint solver impedance: limit
    tendon_solref_fri: PmjtNum;                  // constraint solver reference: friction
    tendon_solimp_fri: PmjtNum;                  // constraint solver impedance: friction
    tendon_range: PmjtNum;                       // tendon length limits
    tendon_actfrcrange: PmjtNum;                 // range of total actuator force
    tendon_margin: PmjtNum;                      // min distance for limit detection
    tendon_stiffness: PmjtNum;                   // linear stiffness coefficient
    tendon_stiffnesspoly: PmjtNum;               // high-order stiffness coefficients
    tendon_damping: PmjtNum;                     // linear damping coefficient
    tendon_dampingpoly: PmjtNum;                 // high-order damping coefficients
    tendon_armature: PmjtNum;                    // inertia associated with tendon velocity
    tendon_frictionloss: PmjtNum;                // loss due to friction
    tendon_lengthspring: PmjtNum;                // spring resting length range
    tendon_length0: PmjtNum;                     // tendon length in qpos0
    tendon_invweight0: PmjtNum;                  // inv. weight in qpos0
    tendon_user: PmjtNum;                        // user data
    tendon_rgba: PmjSingle;                      // rgba when material is omitted
    wrap_type: PmjInt32;                         // wrap object type (mjtWrap)
    wrap_objid: PmjInt32;                        // object id: geom, site, joint
    wrap_prm: PmjtNum;                           // divisor, joint coef, or site id
    actuator_trntype: PmjInt32;                  // transmission type (mjtTrn)
    actuator_dyntype: PmjInt32;                  // dynamics type (mjtDyn)
    actuator_gaintype: PmjInt32;                 // gain type (mjtGain)
    actuator_biastype: PmjInt32;                 // bias type (mjtBias)
    actuator_ctrladr: PmjInt32;                  // address of first control
    actuator_ctrlnum: PmjInt32;                  // number of controls
    actuator_ctrlspec: PmjInt32;                 // input signature, scoped by gaintype
    actuator_outadr: PmjInt32;                   // address of first force output
    actuator_outnum: PmjInt32;                   // number of force outputs, from trntype
    actuator_actadr: PmjInt32;                   // first activation address; -1: stateless
    actuator_actnum: PmjInt32;                   // number of activation variables
    actuator_trnid: PmjInt32;                    // transmission id: joint, tendon, site
    actuator_cranklength: PmjtNum;               // crank length for slider-crank
    actuator_dynprm: PmjtNum;                    // dynamics parameters
    actuator_gainprm: PmjtNum;                   // gain parameters
    actuator_biasprm: PmjtNum;                   // bias parameters
    actuator_actlimited: PmjtBool;               // is activation limited
    actuator_actrange: PmjtNum;                  // range of activations
    actuator_actearly: PmjtBool;                 // step activation before force
    actuator_history: PmjInt32;                  // history buffer: [nsample, interp]
    actuator_historyadr: PmjInt32;               // address in history buffer; -1: none
    actuator_delay: PmjtNum;                     // delay time; 0: no delay
    actuator_damping: PmjtNum;                   // linear damping coefficient
    actuator_dampingpoly: PmjtNum;               // high-order damping coefficients
    actuator_armature: PmjtNum;                  // armature added to target (joint, tendon)
    actuator_group: PmjInt32;                    // group for visibility
    actuator_user: PmjtNum;                      // user data
    actuator_plugin: PmjInt32;                   // plugin instance id; -1: not a plugin
    actuator_forcelimited: PmjtBool;             // is force limited
    actuator_forcerange: PmjtNum;                // range of forces
    actuator_ctrllimited: PmjtBool;              // is control limited
    actuator_ctrlrange: PmjtNum;                 // range of controls
    actuator_gear: PmjtNum;                      // scale length and transmitted force
    actuator_acc0: PmjtNum;                      // acceleration from unit force in qpos0
    actuator_length0: PmjtNum;                   // actuator length in qpos0
    actuator_lengthrange: PmjtNum;               // feasible actuator length range
    sensor_type: PmjInt32;                       // sensor type (mjtSensor)
    sensor_datatype: PmjInt32;                   // numeric data type (mjtDataType)
    sensor_needstage: PmjInt32;                  // required compute stage (mjtStage)
    sensor_objtype: PmjInt32;                    // type of sensorized object (mjtObj)
    sensor_objid: PmjInt32;                      // id of sensorized object
    sensor_reftype: PmjInt32;                    // type of reference frame (mjtObj)
    sensor_refid: PmjInt32;                      // id of reference frame; -1: global frame
    sensor_intprm: PmjInt32;                     // sensor parameters
    sensor_dim: PmjInt32;                        // number of scalar outputs
    sensor_adr: PmjInt32;                        // address in sensor array
    sensor_cutoff: PmjtNum;                      // cutoff for real and positive; 0: ignore
    sensor_noise: PmjtNum;                       // noise standard deviation
    sensor_history: PmjInt32;                    // history buffer: [nsample, interp]
    sensor_historyadr: PmjInt32;                 // address in history buffer; -1: none
    sensor_delay: PmjtNum;                       // delay time in seconds; 0: no delay
    sensor_interval: PmjtNum;                    // interval: [period, phase] in seconds
    sensor_user: PmjtNum;                        // user data
    sensor_plugin: PmjInt32;                     // plugin instance id; -1: not a plugin
    plugin: PmjInt32;                            // globally registered plugin slot number
    plugin_stateadr: PmjInt32;                   // address in the plugin state array
    plugin_statenum: PmjInt32;                   // number of states in the plugin instance
    plugin_attr: PAnsiChar;                      // config attributes of plugin instances
    plugin_attradr: PmjInt32;                    // address to each instance's config attrib
    numeric_adr: PmjInt32;                       // address of field in numeric_data
    numeric_size: PmjInt32;                      // size of numeric field
    numeric_data: PmjtNum;                       // array of all numeric fields
    text_adr: PmjInt32;                          // address of text in text_data
    text_size: PmjInt32;                         // size of text field (strlen+1)
    text_data: PAnsiChar;                        // array of all text fields (0-terminated)
    tuple_adr: PmjInt32;                         // address of text in text_data
    tuple_size: PmjInt32;                        // number of objects in tuple
    tuple_objtype: PmjInt32;                     // array of object types in all tuples
    tuple_objid: PmjInt32;                       // array of object ids in all tuples
    tuple_objprm: PmjtNum;                       // array of object params in all tuples
    key_time: PmjtNum;                           // key time
    key_qpos: PmjtNum;                           // key position
    key_qvel: PmjtNum;                           // key velocity
    key_act: PmjtNum;                            // key activation
    key_mpos: PmjtNum;                           // key mocap position
    key_mquat: PmjtNum;                          // key mocap quaternion
    key_ctrl: PmjtNum;                           // key control
    name_bodyadr: PmjInt32;                      // body name pointers
    name_jntadr: PmjInt32;                       // joint name pointers
    name_geomadr: PmjInt32;                      // geom name pointers
    name_siteadr: PmjInt32;                      // site name pointers
    name_camadr: PmjInt32;                       // camera name pointers
    name_lightadr: PmjInt32;                     // light name pointers
    name_flexadr: PmjInt32;                      // flex name pointers
    name_meshadr: PmjInt32;                      // mesh name pointers
    name_skinadr: PmjInt32;                      // skin name pointers
    name_hfieldadr: PmjInt32;                    // hfield name pointers
    name_texadr: PmjInt32;                       // texture name pointers
    name_matadr: PmjInt32;                       // material name pointers
    name_pairadr: PmjInt32;                      // geom pair name pointers
    name_excludeadr: PmjInt32;                   // exclude name pointers
    name_eqadr: PmjInt32;                        // equality constraint name pointers
    name_tendonadr: PmjInt32;                    // tendon name pointers
    name_actuatoradr: PmjInt32;                  // actuator name pointers
    name_sensoradr: PmjInt32;                    // sensor name pointers
    name_numericadr: PmjInt32;                   // numeric name pointers
    name_textadr: PmjInt32;                      // text name pointers
    name_tupleadr: PmjInt32;                     // tuple name pointers
    name_keyadr: PmjInt32;                       // keyframe name pointers
    name_pluginadr: PmjInt32;                    // plugin instance name pointers
    names: PAnsiChar;                            // names of all objects, 0-terminated
    names_map: PmjInt32;                         // internal hash map of names
    paths: PAnsiChar;                            // resolved paths to assets, 0-terminated
    B_rownnz: PmjInt32;                          // body-dof: non-zeros in each row
    B_rowadr: PmjInt32;                          // body-dof: row addresses
    B_colind: PmjInt32;                          // body-dof: column indices
    M_rownnz: PmjInt32;                          // reduced inertia: non-zeros in each row
    M_rowadr: PmjInt32;                          // reduced inertia: row addresses
    M_colind: PmjInt32;                          // reduced inertia: column indices
    mapM2M: PmjInt32;                            // index mapping from qM to M
    D_rownnz: PmjInt32;                          // full inertia: non-zeros in each row
    D_rowadr: PmjInt32;                          // full inertia: row addresses
    D_diag: PmjInt32;                            // full inertia: index of diagonal element
    D_colind: PmjInt32;                          // full inertia: column indices
    mapM2D: PmjInt32;                            // index mapping from M to D
    mapD2M: PmjInt32;                            // index mapping from D to M
    signature: UInt64;                           // also held by the mjSpec that compiled this model
  end;

  mjPreContact = record
    dist: mjtNum;
    pos: array[0..2] of mjtNum;
    normal: array[0..2] of mjtNum;               // contact normal of the collision
    tangent: array[0..2] of mjtNum;              // first tangent direction
  end;

  mjContact = record
    dist: mjtNum;                                // distance between nearest points; neg: penetration
    pos: array[0..2] of mjtNum;                  // position of contact point: midpoint between geoms
    frame: array[0..8] of mjtNum;                // normal is in [0-2], points from geom[0] to geom[1]
    includemargin: mjtNum;                       // margin for force generation
    friction: array[0..4] of mjtNum;             // tangent1, 2, spin, roll1, 2
    solref: array[0..1] of mjtNum;               // constraint solver reference, normal direction
    solreffriction: array[0..1] of mjtNum;       // constraint solver reference, friction directions
    solimp: array[0..4] of mjtNum;               // constraint solver impedance
    adhesion: mjtNum;                            // adhesive force along the contact normal
    mu: mjtNum;                                  // friction of regularized cone, set by mj_makeConstraint
    H: array[0..35] of mjtNum;                   // cone Hessian, set by mj_constraintUpdate
    dim: Int32;                                  // contact space dimensionality: 1, 3, 4 or 6
    geom1: Int32;                                // id of geom 1; deprecated, use geom[0]
    geom2: Int32;                                // id of geom 2; deprecated, use geom[1]
    geom: array[0..1] of Int32;                  // geom ids; -1 for flex
    flex: array[0..1] of Int32;                  // flex ids; -1 for geom
    elem: array[0..1] of Int32;                  // element ids; -1 for geom or flex vertex
    vert: array[0..1] of Int32;                  // vertex ids; -1 for geom or flex element
    exclude: Int32;                              // 0: include, 1: in gap, 2: fused, 3: no dofs, 4: passive
    efc_address: Int32;                          // address in efc; -1: not included
  end;

  mjWarningStat = record
    lastinfo: Int32;                             // info from last warning
    number: Int32;                               // how many times was warning raised
  end;

  mjTimerStat = record
    duration: mjtNum;                            // cumulative duration
    number: Int32;                               // how many times was timer called
  end;

  mjSolverStat = record
    improvement: mjtNum;                         // cost reduction, scaled by 1/trace(M)
    gradient: mjtNum;                            // gradient norm (primal only, scaled)
    lineslope: mjtNum;                           // slope in linesearch
    nactive: Int32;                              // number of active constraints
    nchange: Int32;                              // number of constraint state changes
    neval: Int32;                                // number of cost evaluations in line search
    nupdate: Int32;                              // number of Cholesky updates in line search
  end;

  mjData = record
    narena: mjtSize;                             // size of the arena in bytes (inclusive of the stack)
    nbuffer: mjtSize;                            // size of main buffer in bytes
    nplugin: Int32;                              // number of plugin instances
    pstack: NativeUInt;                          // first available byte in stack (mutable)
    pbase: NativeUInt;                           // value of pstack when mj_markStack was last called (mutable)
    parena: NativeUInt;                          // first available byte in arena
    threadpool: NativeUInt;                      // thread pool pointer
    threadlock: mjtBool;                         // disable stack freeing during threaded execution
    maxuse_stack: mjtSize;                       // maximum stack allocation in bytes (mutable)
    maxuse_arena: mjtSize;                       // maximum arena allocation in bytes
    maxuse_con: Int32;                           // maximum number of contacts
    maxuse_efc: Int32;                           // maximum number of scalar constraints
    solver: array[0..3999] of mjSolverStat;      // solver statistics per island, per iteration
    solver_niter: array[0..19] of Int32;         // number of solver iterations, per island
    solver_nnz: array[0..19] of Int32;           // number of nonzeros in solver matrix, per island
    solver_fwdinv: array[0..1] of mjtNum;        // forward-inverse comparison: qfrc, efc
    warning: array[0..6] of mjWarningStat;       // warning statistics (mutable)
    timer: array[0..14] of mjTimerStat;          // timer statistics
    ncon: Int32;                                 // number of detected contacts
    ne: Int32;                                   // number of equality constraints
    nf: Int32;                                   // number of friction constraints
    nl: Int32;                                   // number of limit constraints
    nefc: Int32;                                 // number of constraints
    nJ: Int32;                                   // number of non-zeros in constraint Jacobian
    efm_active: Int32;                           // implicit effective metric M+K is active (see mj_effBuild)
    nefmK: Int32;                                // number of non-zeros in effective-stiffness CSR
    nefmcon: Int32;                              // packed length of the contact rank-1 rows
    nefmT: Int32;                                // number of tendons with terms in the metric
    nefmA: Int32;                                // number of actuators with terms in the metric
    nefmdof: Int32;                              // number of 3x3 blocks in the effective-metric preconditioner
    nefmL: Int32;                                // size of efm_L (9*nefmdof plus optional Cholesky or island tail)
    nY: Int32;                                   // number of non-zeros in constraint inverse inertia square root
    nA: Int32;                                   // number of non-zeros in constraint inverse inertia matrix
    nisland: Int32;                              // number of detected constraint islands
    nidof: Int32;                                // number of dofs in all islands
    ntree_awake: Int32;                          // number of awake trees
    nbody_awake: Int32;                          // number of awake dynamic and static bodies
    nparent_awake: Int32;                        // number of bodies with awake parents
    nv_awake: Int32;                             // number of awake dofs
    flg_energypos: mjtBool;                      // has mj_energyPos been called
    flg_energyvel: mjtBool;                      // has mj_energyVel been called
    flg_subtreevel: mjtBool;                     // has mj_subtreeVel been called
    flg_rnepost: mjtBool;                        // has mj_rnePostConstraint been called
    time: mjtNum;                                // simulation time
    energy: array[0..1] of mjtNum;               // potential, kinetic energy
    buffer: Pointer;                             // main buffer; all pointers point in it (nbuffer bytes)
    arena: Pointer;                              // arena+stack buffer (narena bytes)
    qpos: PmjtNum;                               // position
    qvel: PmjtNum;                               // velocity
    act: PmjtNum;                                // actuator activation
    history: PmjtNum;                            // history buffer
    qacc_warmstart: PmjtNum;                     // acceleration used for warmstart
    plugin_state: PmjtNum;                       // plugin state
    ctrl: PmjtNum;                               // control
    qfrc_applied: PmjtNum;                       // applied generalized force
    xfrc_applied: PmjtNum;                       // applied Cartesian force/torque
    eq_active: PmjtBool;                         // enable/disable constraints
    mocap_pos: PmjtNum;                          // positions of mocap bodies
    mocap_quat: PmjtNum;                         // orientations of mocap bodies
    qacc: PmjtNum;                               // acceleration
    act_dot: PmjtNum;                            // time-derivative of actuator activation
    userdata: PmjtNum;                           // user data, not touched by engine
    sensordata: PmjtNum;                         // sensor data array
    tree_asleep: PmjInt32;                       // <0: awake; >=0: index cycle of sleeping trees
    plugin: PmjInt32;                            // copy of m->plugin, required for deletion
    plugin_data: PmjNativeUInt;                  // pointer to plugin-managed data structure
    xpos: PmjtNum;                               // Cartesian position of body frame
    xquat: PmjtNum;                              // Cartesian orientation of body frame
    xmat: PmjtNum;                               // Cartesian orientation of body frame
    xipos: PmjtNum;                              // Cartesian position of body com
    ximat: PmjtNum;                              // Cartesian orientation of body inertia
    xanchor: PmjtNum;                            // Cartesian position of joint anchor
    xaxis: PmjtNum;                              // Cartesian joint axis
    geom_xpos: PmjtNum;                          // Cartesian geom position
    geom_xmat: PmjtNum;                          // Cartesian geom orientation
    site_xpos: PmjtNum;                          // Cartesian site position
    site_xmat: PmjtNum;                          // Cartesian site orientation
    cam_xpos: PmjtNum;                           // Cartesian camera position
    cam_xmat: PmjtNum;                           // Cartesian camera orientation
    light_xpos: PmjtNum;                         // Cartesian light position
    light_xdir: PmjtNum;                         // Cartesian light direction
    subtree_com: PmjtNum;                        // center of mass of each subtree
    cdof: PmjtNum;                               // com-based motion axis of each dof (rot:lin)
    cinert: PmjtNum;                             // com-based body inertia and mass
    flexvert_xpos: PmjtNum;                      // Cartesian flex vertex positions
    flexelem_aabb: PmjtNum;                      // flex element bounding boxes (center, size)
    flexelem_krot: PmjtNum;                      // corotated element stiffness (implicit only)
    flex_hessian_valid: PmjtBool;                // Cartesian stretch Hessian cache is current
    flexvert_hessian: PmjtNum;                   // symmetric diagonal Hessian blocks
    flexedge_hessian: PmjtNum;                   // oriented off-diagonal Hessian blocks
    flexedge_J: PmjtNum;                         // flex edge Jacobian
    flexedge_length: PmjtNum;                    // flex edge lengths
    flexvert_J: PmjtNum;                         // flex vertex Jacobian
    flexvert_length: PmjtNum;                    // flex vertex lengths
    bvh_aabb_dyn: PmjtNum;                       // global bounding box (center, size)
    flexvert_lambda: PmjtNum;                    // flex contact multiplier
    flexvert_conage: PmjInt32;                   // flex contact age: <0 loaded, >0 steps since
    ten_wrapadr: PmjInt32;                       // start address of tendon's path
    ten_wrapnum: PmjInt32;                       // number of wrap points in path
    ten_J: PmjtNum;                              // tendon Jacobian
    ten_length: PmjtNum;                         // tendon lengths
    wrap_obj: PmjInt32;                          // geom id; -1: site; -2: pulley
    wrap_xpos: PmjtNum;                          // Cartesian 3D points in all paths
    actuator_length: PmjtNum;                    // actuator lengths, one per force output
    moment_rownnz: PmjInt32;                     // number of non-zeros in actuator_moment row
    moment_rowadr: PmjInt32;                     // row start address in colind array
    moment_colind: PmjInt32;                     // column indices in sparse Jacobian
    actuator_moment: PmjtNum;                    // actuator moments
    crb: PmjtNum;                                // com-based composite inertia and mass
    M: PmjtNum;                                  // inertia (sparse)
    qLD: PmjtNum;                                // L'*D*L factorization of M (sparse)
    qLDiagInv: PmjtNum;                          // 1/diag(D)
    bvh_active: PmjtBool;                        // was bounding volume checked for collision
    tree_awake: PmjInt32;                        // is tree awake; 0: asleep; 1: awake
    body_awake: PmjInt32;                        // body sleep state (mjtSleepState)
    body_awake_ind: PmjInt32;                    // indices of awake and static bodies
    parent_awake_ind: PmjInt32;                  // indices of bodies with awake or static parents
    dof_awake_ind: PmjInt32;                     // indices of awake dofs
    flexedge_velocity: PmjtNum;                  // flex edge velocities
    ten_velocity: PmjtNum;                       // tendon velocities
    actuator_velocity: PmjtNum;                  // actuator velocities, one per force output
    cvel: PmjtNum;                               // com-based velocity (rot:lin)
    cdof_dot: PmjtNum;                           // time-derivative of cdof (rot:lin)
    qfrc_bias: PmjtNum;                          // C(qpos,qvel)
    qfrc_spring: PmjtNum;                        // passive spring force
    qfrc_damper: PmjtNum;                        // passive damper force
    qfrc_gravcomp: PmjtNum;                      // passive gravity compensation force
    qfrc_fluid: PmjtNum;                         // passive fluid force
    qfrc_adhesion: PmjtNum;                      // passive contact adhesion force
    qfrc_passive: PmjtNum;                       // total passive force
    subtree_linvel: PmjtNum;                     // linear velocity of subtree com
    subtree_angmom: PmjtNum;                     // angular momentum about subtree com
    qH: PmjtNum;                                 // L'*D*L factorization of modified M
    qHDiagInv: PmjtNum;                          // 1/diag(D) of modified M
    qDeriv: PmjtNum;                             // d (passive + actuator - bias) / d qvel
    qLU: PmjtNum;                                // sparse LU of (M - dt*qDeriv)
    actuator_force: PmjtNum;                     // actuator force in actuation space
    qfrc_actuator: PmjtNum;                      // actuator force in joint space
    qfrc_smooth: PmjtNum;                        // net unconstrained force
    qacc_smooth: PmjtNum;                        // unconstrained acceleration
    qfrc_constraint: PmjtNum;                    // constraint force (flag ipc: incl. flex contact)
    qfrc_inverse: PmjtNum;                       // net external force; should equal: qfrc_applied + J'*xfrc_applied + qfrc_actuator
    cacc: PmjtNum;                               // com-based acceleration
    cfrc_int: PmjtNum;                           // com-based interaction force with parent
    cfrc_ext: PmjtNum;                           // com-based external force on body
    contact: PmjContact;                         // array of all detected contacts
    efc_type: PmjInt32;                          // constraint type (mjtConstraint)
    efc_id: PmjInt32;                            // id of object of specified type
    efc_J_rownnz: PmjInt32;                      // number of non-zeros in constraint Jacobian row
    efc_J_rowadr: PmjInt32;                      // row start address in colind array
    efc_J_rowsuper: PmjInt32;                    // number of subsequent rows in supernode
    efc_J_colind: PmjInt32;                      // column indices in constraint Jacobian
    efc_J: PmjtNum;                              // constraint Jacobian
    efc_pos: PmjtNum;                            // constraint position (equality, contact)
    efc_margin: PmjtNum;                         // inclusion margin (contact)
    efc_frictionloss: PmjtNum;                   // frictionloss (friction)
    efc_diagA: PmjtNum;                          // diagonal of A matrix, approximate or exact
    efc_KBIP: PmjtNum;                           // stiffness, damping, impedance, imp'
    efc_D: PmjtNum;                              // constraint mass
    efc_R: PmjtNum;                              // inverse constraint mass
    tendon_efcadr: PmjInt32;                     // first efc address involving tendon; -1: none
    tree_island: PmjInt32;                       // island id of this tree; -1: none
    island_ntree: PmjInt32;                      // number of trees in this island
    island_itreeadr: PmjInt32;                   // island start address in itree vector
    map_itree2tree: PmjInt32;                    // map from itree to tree
    dof_island: PmjInt32;                        // island id of this dof; -1: none
    island_nv: PmjInt32;                         // number of dofs in this island
    island_idofadr: PmjInt32;                    // island start address in idof vector
    island_dofadr: PmjInt32;                     // island start address in dof vector
    map_dof2idof: PmjInt32;                      // map from dof to idof
    map_idof2dof: PmjInt32;                      // map from idof to dof; >= nidof: unconstrained
    ifrc_smooth: PmjtNum;                        // net unconstrained force
    iacc_smooth: PmjtNum;                        // unconstrained acceleration
    iacc: PmjtNum;                               // acceleration
    efc_island: PmjInt32;                        // island id of this constraint
    island_ne: PmjInt32;                         // number of equality constraints in island
    island_nf: PmjInt32;                         // number of friction constraints in island
    island_nefc: PmjInt32;                       // number of constraints in island
    island_iefcadr: PmjInt32;                    // start address in iefc vector
    map_efc2iefc: PmjInt32;                      // map from efc to iefc
    map_iefc2efc: PmjInt32;                      // map from iefc to efc
    iefc_type: PmjInt32;                         // constraint type (mjtConstraint)
    iefc_id: PmjInt32;                           // id of object of specified type
    iefc_frictionloss: PmjtNum;                  // frictionloss (friction)
    iefc_D: PmjtNum;                             // constraint mass
    iefc_R: PmjtNum;                             // inverse constraint mass
    efc_Y_rownnz: PmjInt32;                      // number of non-zeros in Y row
    efc_Y_rowadr: PmjInt32;                      // row start address in Y colind array
    efc_Y_colind: PmjInt32;                      // column indices in sparse Y
    efc_Y: PmjtNum;                              // whitened Jacobian Y = J*M^(-1/2)
    efc_AR_rownnz: PmjInt32;                     // number of non-zeros in AR
    efc_AR_rowadr: PmjInt32;                     // row start address in AR colind array
    efc_AR_colind: PmjInt32;                     // column indices in sparse AR
    efc_AR: PmjtNum;                             // J*inv(M)*J' + R
    efc_vel: PmjtNum;                            // velocity in constraint space: J*qvel
    efc_aref: PmjtNum;                           // reference pseudo-acceleration
    efm_c: PmjtNum;                              // smooth-force shift h*K*qvel
    efm_diag: PmjtNum;                           // effective-metric diagonal h*D + h^2*K
    efm_ck: PmjtNum;                             // diagonal stiffness h*k, for the smooth shift
    efm_sdiag: PmjtNum;                          // diagonal additions to M in the backbone
    efm_fluid: PmjtNum;                          // fluid drag blocks in M's sparsity pattern
    efm_tid: PmjInt32;                           // ids of tendons with terms in the metric
    efm_ts: PmjtNum;                             // tendon metric scale h^2*k + h*b, tid indexed
    efm_tk: PmjtNum;                             // tendon stiffness h*k for shift, tid indexed
    efm_aid: PmjInt32;                           // ids of actuators with terms in the metric
    efm_as: PmjtNum;                             // actuator metric scale h^2*gp + h*gv, aid indexed
    efm_ak: PmjtNum;                             // actuator stiffness h*gp, aid indexed
    efm_ca: PmjtNum;                             // actuation-stage smooth-force shift
    efm_K_rownnz: PmjInt32;                      // effective-stiffness CSR row nonzeros
    efm_K_rowadr: PmjInt32;                      // effective-stiffness CSR row addresses
    efm_K_colind: PmjInt32;                      // effective-stiffness CSR column indices
    efm_K_val: PmjtNum;                          // effective-stiffness CSR values
    efm_dofid: PmjInt32;                         // block k -> dof address of its vertex triple
    efm_con_ind: PmjInt32;                       // contact rows, packed [nnz, conid, colind...]
    efm_con_val: PmjtNum;                        // contact rows, packed [scale, force, val...]
    efm_L: PmjtNum;                              // factored 3x3 blocks of M+K and packed tail data
    efc_b: PmjtNum;                              // linear cost term: J*qacc_smooth - aref
    iefc_aref: PmjtNum;                          // reference pseudo-acceleration
    iefc_state: PmjInt32;                        // constraint state (mjtConstraintState)
    iefc_force: PmjtNum;                         // constraint force in constraint space
    efc_state: PmjInt32;                         // constraint state (mjtConstraintState)
    efc_force: PmjtNum;                          // constraint force in constraint space
    ifrc_constraint: PmjtNum;                    // constraint force
    signature: UInt64;                           // also held by the mjSpec that compiled the model
  end;

  mjsElement = record
    elemtype: mjtObj;                            // element type
    signature: UInt64;                           // compilation signature
  end;

  mjsCompiler = record
    autolimits: mjtBool;                         // infer "limited" attribute based on range
    boundmass: Double;                           // enforce minimum body mass
    boundinertia: Double;                        // enforce minimum body diagonal inertia
    settotalmass: Double;                        // (deprecated) rescale masses and inertias; <=0: ignore
    balanceinertia: mjtBool;                     // automatically impose A + B >= C rule
    fitaabb: mjtBool;                            // meshfit to aabb instead of inertia box
    degree: mjtBool;                             // angles in radians or degrees
    eulerseq: array[0..2] of AnsiChar;           // sequence for euler rotations
    discardvisual: mjtBool;                      // discard visual geoms in parser
    usethread: mjtBool;                          // use multiple threads to speed up compiler
    fusestatic: mjtBool;                         // fuse static bodies with parent
    inertiafromgeom: mjtInertiaFromGeom;         // use geom inertias
    inertiagrouprange: array[0..1] of Int32;     // range of geom groups used to compute inertia
    saveinertial: mjtBool;                       // save explicit inertial clause for all bodies to XML
    savecompiled: mjtBool;                       // save values as compiled, not as written in the spec
    savecanonical: mjtBool;                      // save quaternions and radians, not the notation of the spec
    alignfree: mjtBool;                          // align free joints with inertial frame
    conflict: mjtConflict;                       // conflict resolution for attach
    passthrough: mjtPassthrough;                 // assets left by reference (bitmask)
    LRopt: mjLROpt;                              // options for lengthrange computation
    meshdir: Pointer;                            // mesh and hfield directory
    texturedir: Pointer;                         // texture directory
    authored: UInt64;                            // bitmask of authored compiler fields
  end;

  mjsAuthored = record
    option: UInt64;                              // authored mjOption fields
    disableflags: Int32;                         // individual authored disable flags
    enableflags: Int32;                          // individual authored enable flags
    disableactuator: Int32;                      // individual authored actuator groups
    visual_global: UInt64;                       // authored visual.global fields
    visual_quality: UInt64;                      // authored visual.quality fields
    visual_headlight: UInt64;                    // authored visual.headlight fields
    visual_map: UInt64;                          // authored visual.map fields
    visual_scale: UInt64;                        // authored visual.scale fields
    visual_rgba: UInt64;                         // authored visual.rgba fields
  end;

  mjSpec = record
    element: PmjsElement;                        // element type
    modelname: Pointer;                          // model name
    compiler: mjsCompiler;                       // compiler options
    strippath: mjtBool;                          // automatically strip paths from mesh files
    option: mjOption;                            // physics options
    visual: mjVisual;                            // visual options
    stat: mjStatistic;                           // statistics override (if defined)
    memory: mjtSize;                             // number of bytes in arena+stack memory
    nemax: Int32;                                // max number of equality constraints
    nuserdata: Int32;                            // number of mjtNums in userdata
    nuser_body: Int32;                           // number of mjtNums in body_user
    nuser_jnt: Int32;                            // number of mjtNums in jnt_user
    nuser_geom: Int32;                           // number of mjtNums in geom_user
    nuser_site: Int32;                           // number of mjtNums in site_user
    nuser_cam: Int32;                            // number of mjtNums in cam_user
    nuser_tendon: Int32;                         // number of mjtNums in tendon_user
    nuser_actuator: Int32;                       // number of mjtNums in actuator_user
    nuser_sensor: Int32;                         // number of mjtNums in sensor_user
    nkey: Int32;                                 // number of keyframes
    njmax: Int32;                                // (deprecated) max number of constraints
    nconmax: Int32;                              // (deprecated) max number of detected contacts
    nstack: mjtSize;                             // (deprecated) number of mjtNums in mjData stack
    comment: Pointer;                            // comment at top of XML
    modelfiledir: Pointer;                       // path to model file
    hasImplicitPluginElem: mjtBool;              // already encountered an implicit plugin sensor/actuator
    authored: mjsAuthored;                       // authored tracking bitmasks for mjModel structs
  end;

  mjsOrientation = record
    &type: mjtOrientation;                       // active orientation specifier
    axisangle: array[0..3] of Double;            // axis and angle
    xyaxes: array[0..5] of Double;               // x and y axes
    zaxis: array[0..2] of Double;                // z axis (minimal rotation)
    euler: array[0..2] of Double;                // Euler angles
  end;

  mjsPlugin = record
    element: PmjsElement;                        // element type
    name: Pointer;                               // instance name
    plugin_name: Pointer;                        // plugin name
    active: mjtBool;                             // is the plugin active
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsBody = record
    element: PmjsElement;                        // element type
    childclass: Pointer;                         // childclass name
    pos: array[0..2] of Double;                  // frame position
    quat: array[0..3] of Double;                 // frame orientation
    alt: mjsOrientation;                         // frame alternative orientation
    mass: Double;                                // mass
    ipos: array[0..2] of Double;                 // inertial frame position
    iquat: array[0..3] of Double;                // inertial frame orientation
    inertia: array[0..2] of Double;              // diagonal inertia (in i-frame)
    ialt: mjsOrientation;                        // inertial frame alternative orientation
    fullinertia: array[0..5] of Double;          // non-axis-aligned inertia matrix
    mocap: mjtBool;                              // is this a mocap body
    gravcomp: Double;                            // gravity compensation
    sleep: mjtSleepPolicy;                       // sleep policy
    simple: mjtByte;                             // simple body optimization (0: false, 1: auto)
    fuse: mjtByte;                               // fuse with parent when static (0: false, 1: auto)
    userdata: Pointer;                           // user data
    explicitinertial: mjtBool;                   // whether to save the body with explicit inertial clause
    plugin: mjsPlugin;                           // passive force plugin
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsFrame = record
    element: PmjsElement;                        // element type
    childclass: Pointer;                         // childclass name
    pos: array[0..2] of Double;                  // position
    quat: array[0..3] of Double;                 // orientation
    alt: mjsOrientation;                         // alternative orientation
    scale: array[0..2] of Double;                // scale of the frame's contents
    scaling: mjtScaling;                         // physical policy of the scale
    massscale: Double;                           // mass factor of the contents; 0: ratio of volumes
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsJoint = record
    element: PmjsElement;                        // element type
    &type: mjtJoint;                             // joint type
    pos: array[0..2] of Double;                  // anchor position
    axis: array[0..2] of Double;                 // joint axis
    ref: Double;                                 // value at reference configuration: qpos0
    align: mjtAlignFree;                         // align free joint with body com
    stiffness: array[0..2] of Double;            // stiffness coefficients
    springref: Double;                           // spring reference value: qpos_spring
    springdamper: array[0..1] of Double;         // timeconst, dampratio
    limited: mjtLimited;                         // does joint have limits
    range: array[0..1] of Double;                // joint limits
    margin: Double;                              // margin value for joint limit detection
    solref_limit: array[0..1] of mjtNum;         // solver reference: joint limits
    solimp_limit: array[0..4] of mjtNum;         // solver impedance: joint limits
    actfrclimited: mjtLimited;                   // are actuator forces on joint limited
    actfrcrange: array[0..1] of Double;          // actuator force limits
    armature: Double;                            // armature inertia (mass for slider)
    damping: array[0..2] of Double;              // damping coefficients
    frictionloss: Double;                        // friction loss
    solref_friction: array[0..1] of mjtNum;      // solver reference: dof friction
    solimp_friction: array[0..4] of mjtNum;      // solver impedance: dof friction
    group: Int32;                                // group
    actgravcomp: mjtBool;                        // is gravcomp force applied via actuators
    userdata: Pointer;                           // user data
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsGeom = record
    element: PmjsElement;                        // element type
    &type: mjtGeom;                              // geom type
    pos: array[0..2] of Double;                  // position
    quat: array[0..3] of Double;                 // orientation
    alt: mjsOrientation;                         // alternative orientation
    fromto: array[0..5] of Double;               // alternative for capsule, cylinder, box, ellipsoid
    size: array[0..2] of Double;                 // type-specific size
    contype: Int32;                              // contact type
    conaffinity: Int32;                          // contact affinity
    condim: Int32;                               // contact dimensionality
    priority: Int32;                             // contact priority
    friction: array[0..2] of Double;             // one-sided friction coefficients: slide, roll, spin
    solmix: Double;                              // solver mixing for contact pairs
    solref: array[0..1] of mjtNum;               // solver reference
    solimp: array[0..4] of mjtNum;               // solver impedance
    margin: Double;                              // margin for contact detection
    gap: Double;                                 // additional contact detection buffer
    surfacevel: array[0..5] of Double;           // surface velocity in local frame: linear, angular
    adhesion: Double;                            // adhesive force of contacts
    mass: Double;                                // used to compute density
    density: Double;                             // used to compute mass and inertia from volume or surface
    typeinertia: mjtGeomInertia;                 // selects between surface and volume inertia
    fluid_ellipsoid: mjtNum;                     // whether ellipsoid-fluid model is active
    fluid_coefs: array[0..4] of mjtNum;          // ellipsoid-fluid interaction coefs
    material: Pointer;                           // name of material
    rgba: array[0..3] of Single;                 // rgba when material is omitted
    group: Int32;                                // group
    hfieldname: Pointer;                         // heightfield attached to geom
    meshname: Pointer;                           // mesh attached to geom
    fitscale: Double;                            // scale mesh uniformly
    userdata: Pointer;                           // user data
    plugin: mjsPlugin;                           // sdf plugin
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsSite = record
    element: PmjsElement;                        // element type
    pos: array[0..2] of Double;                  // position
    quat: array[0..3] of Double;                 // orientation
    alt: mjsOrientation;                         // alternative orientation
    fromto: array[0..5] of Double;               // alternative for capsule, cylinder, box, ellipsoid
    size: array[0..2] of Double;                 // geom size
    &type: mjtGeom;                              // geom type
    material: Pointer;                           // name of material
    group: Int32;                                // group
    rgba: array[0..3] of Single;                 // rgba when material is omitted
    meshname: Pointer;                           // mesh attached to site
    userdata: Pointer;                           // user data
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsCamera = record
    element: PmjsElement;                        // element type
    pos: array[0..2] of Double;                  // position
    quat: array[0..3] of Double;                 // orientation
    alt: mjsOrientation;                         // alternative orientation
    mode: mjtCamLight;                           // tracking mode
    targetbody: Pointer;                         // target body for tracking/targeting
    proj: mjtProjection;                         // camera projection type
    resolution: array[0..1] of Int32;            // resolution (pixel)
    output: Int32;                               // bit flags for output type
    fovy: Double;                                // y-field of view
    ipd: Double;                                 // inter-pupillary distance
    intrinsic: array[0..3] of Single;            // camera intrinsics (length)
    sensor_size: array[0..1] of Single;          // sensor size (length)
    focal_length: array[0..1] of Single;         // focal length (length)
    focal_pixel: array[0..1] of Single;          // focal length (pixel)
    principal_length: array[0..1] of Single;     // principal point (length)
    principal_pixel: array[0..1] of Single;      // principal point (pixel)
    userdata: Pointer;                           // user data
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsLight = record
    element: PmjsElement;                        // element type
    pos: array[0..2] of Double;                  // position
    dir: array[0..2] of Double;                  // direction
    mode: mjtCamLight;                           // tracking mode
    targetbody: Pointer;                         // target body for targeting
    active: mjtBool;                             // is light active
    &type: mjtLightType;                         // type of light
    texture: Pointer;                            // texture name for image lights
    castshadow: mjtBool;                         // does light cast shadows
    bulbradius: Single;                          // bulb radius, for soft shadows
    intensity: Single;                           // intensity, in candelas
    range: Single;                               // range of effectiveness
    attenuation: array[0..2] of Single;          // OpenGL attenuation (quadratic model)
    cutoff: Single;                              // OpenGL cutoff
    softness: Single;                            // spotlight edge softness
    exponent: Single;                            // OpenGL exponent
    ambient: array[0..2] of Single;              // ambient color
    diffuse: array[0..2] of Single;              // diffuse color
    specular: array[0..2] of Single;             // specular color
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsFlex = record
    element: PmjsElement;                        // element type
    contype: Int32;                              // contact type
    conaffinity: Int32;                          // contact affinity
    condim: Int32;                               // contact dimensionality
    priority: Int32;                             // contact priority
    friction: array[0..2] of Double;             // one-sided friction coefficients: slide, roll, spin
    solmix: Double;                              // solver mixing for contact pairs
    solref: array[0..1] of mjtNum;               // solver reference
    solimp: array[0..4] of mjtNum;               // solver impedance
    margin: Double;                              // margin for contact detection
    gap: Double;                                 // additional contact detection buffer
    dim: Int32;                                  // element dimensionality
    radius: Double;                              // radius around primitive element
    size: array[0..2] of Double;                 // vertex bounding box half sizes in qpos0
    flatskin: mjtBool;                           // render flex skin with flat shading
    selfcollide: mjtFlexSelf;                    // mode for flex self collision
    passive: Int32;                              // mode for passive collisions
    activelayers: Int32;                         // number of active element layers in 3D
    group: Int32;                                // group for visualization
    edgestiffness: Double;                       // edge stiffness
    edgedamping: Double;                         // edge damping
    rgba: array[0..3] of Single;                 // rgba when material is omitted
    material: Pointer;                           // name of material used for rendering
    young: Double;                               // Young's modulus
    poisson: Double;                             // Poisson's ratio
    damping: Double;                             // Rayleigh's damping
    thickness: Double;                           // thickness (2D only)
    elastic2d: Int32;                            // 2D passive forces; 0: none, 1: bending, 2: stretching, 3: both
    elastic3d: Int32;                            // experimental 3D material (mjSpec only); 0: Saint Venant-Kirchhoff, 1: Stable Neo-Hookean
    section: mjtFlexSection;                     // 1D cross-section (mjtFlexSection)
    sectionsize: array[0..1] of Double;          // 1D box cross-section half-sizes
    cellcount: array[0..2] of Int32;             // grid cell count for finite cell method
    order: Int32;                                // interpolation order (1: trilinear, 2: quadratic)
    nodebody: Pointer;                           // node body names
    vertbody: Pointer;                           // vertex body names
    node: Pointer;                               // node positions
    vert: Pointer;                               // vertex positions
    elem: Pointer;                               // element vertex ids
    texcoord: Pointer;                           // vertex texture coordinates
    elemtexcoord: Pointer;                       // element texture coordinates
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsMesh = record
    element: PmjsElement;                        // element type
    content_type: Pointer;                       // content type of file
    &file: Pointer;                              // mesh file
    refpos: array[0..2] of Double;               // reference position
    refquat: array[0..3] of Double;              // reference orientation
    scale: array[0..2] of Double;                // rescale mesh
    inertia: mjtMeshInertia;                     // inertia type (convex, legacy, exact, shell)
    smoothnormal: mjtBool;                       // do not exclude large-angle faces from normals
    needsdf: mjtBool;                            // compute sdf from mesh
    maxhullvert: Int32;                          // maximum vertex count for the convex hull
    uservert: Pointer;                           // user vertex data
    usernormal: Pointer;                         // user normal data
    usertexcoord: Pointer;                       // user texcoord data
    userface: Pointer;                           // user vertex indices
    userfacenormal: Pointer;                     // user face normal indices
    userfacetexcoord: Pointer;                   // user texcoord indices
    usernode: Pointer;                           // user volume node coordinates
    usertet: Pointer;                            // user tetrahedral cell indices
    plugin: mjsPlugin;                           // sdf plugin
    material: Pointer;                           // name of material
    octree_maxdepth: Int32;                      // max octree depth
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsHField = record
    element: PmjsElement;                        // element type
    content_type: Pointer;                       // content type of file
    &file: Pointer;                              // file: (nrow, ncol, [elevation data])
    size: array[0..3] of Double;                 // hfield size (ignore referencing geom size)
    nrow: Int32;                                 // number of rows
    ncol: Int32;                                 // number of columns
    userdata: Pointer;                           // user-provided elevation data
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsSkin = record
    element: PmjsElement;                        // element type
    &file: Pointer;                              // skin file
    material: Pointer;                           // name of material used for rendering
    rgba: array[0..3] of Single;                 // rgba when material is omitted
    inflate: Single;                             // inflate in normal direction
    group: Int32;                                // group for visualization
    vert: Pointer;                               // vertex positions
    texcoord: Pointer;                           // texture coordinates
    face: Pointer;                               // faces
    bodyname: Pointer;                           // body names
    bindpos: Pointer;                            // bind pos
    bindquat: Pointer;                           // bind quat
    vertid: Pointer;                             // vertex ids
    vertweight: Pointer;                         // vertex weights
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsTexture = record
    element: PmjsElement;                        // element type
    &type: mjtTexture;                           // texture type
    colorspace: mjtColorSpace;                   // colorspace
    builtin: mjtBuiltin;                         // builtin type
    mark: mjtMark;                               // mark type
    rgb1: array[0..2] of Double;                 // first color for builtin
    rgb2: array[0..2] of Double;                 // second color for builtin
    markrgb: array[0..2] of Double;              // mark color
    random: Double;                              // probability of random dots
    height: Int32;                               // height in pixels (square for cube and skybox)
    width: Int32;                                // width in pixels
    nchannel: Int32;                             // number of channels
    content_type: Pointer;                       // content type of file
    &file: Pointer;                              // png file to load; use for all sides of cube
    gridsize: array[0..1] of Int32;              // size of grid for composite file; (1,1)-repeat
    gridlayout: array[0..11] of AnsiChar;        // row-major: L,R,F,B,U,D for faces; . for unused
    cubefiles: Pointer;                          // different file for each side of the cube
    data: Pointer;                               // texture data
    hflip: mjtBool;                              // horizontal flip
    vflip: mjtBool;                              // vertical flip
    embed: mjtEmbed;                             // pixels in the model, or the file by reference
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsMaterial = record
    element: PmjsElement;                        // element type
    textures: Pointer;                           // names of textures (empty: none)
    texuniform: mjtBool;                         // make texture cube uniform
    texrepeat: array[0..1] of Single;            // texture repetition for 2D mapping
    emission: Single;                            // emission
    specular: Single;                            // specular
    shininess: Single;                           // shininess
    reflectance: Single;                         // reflectance
    metallic: Single;                            // metallic
    roughness: Single;                           // roughness
    rgba: array[0..3] of Single;                 // rgba
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsPair = record
    element: PmjsElement;                        // element type
    geomname1: Pointer;                          // name of geom 1
    geomname2: Pointer;                          // name of geom 2
    condim: Int32;                               // contact dimensionality
    solref: array[0..1] of mjtNum;               // solver reference, normal direction
    solreffriction: array[0..1] of mjtNum;       // solver reference, frictional directions
    solimp: array[0..4] of mjtNum;               // solver impedance
    margin: Double;                              // margin for contact detection
    gap: Double;                                 // additional contact detection buffer
    adhesion: Double;                            // adhesive force of contacts
    friction: array[0..4] of Double;             // full contact friction
    info: Pointer;                               // message appended to errors
  end;

  mjsExclude = record
    element: PmjsElement;                        // element type
    bodyname1: Pointer;                          // name of geom 1
    bodyname2: Pointer;                          // name of geom 2
    info: Pointer;                               // message appended to errors
  end;

  mjsEquality = record
    element: PmjsElement;                        // element type
    &type: mjtEq;                                // constraint type
    data: array[0..11] of Double;                // type-dependent data
    active: mjtBool;                             // is equality initially active
    name1: Pointer;                              // name of object 1
    name2: Pointer;                              // name of object 2
    objtype: mjtObj;                             // type of both objects
    solref: array[0..1] of mjtNum;               // solver reference
    solimp: array[0..4] of mjtNum;               // solver impedance
    info: Pointer;                               // message appended to errors
  end;

  mjsTendon = record
    element: PmjsElement;                        // element type
    stiffness: array[0..2] of Double;            // stiffness coefficients
    springlength: array[0..1] of Double;         // spring resting length; {-1, -1}: use qpos_spring
    damping: array[0..2] of Double;              // damping coefficients
    frictionloss: Double;                        // friction loss
    solref_friction: array[0..1] of mjtNum;      // solver reference: tendon friction
    solimp_friction: array[0..4] of mjtNum;      // solver impedance: tendon friction
    armature: Double;                            // inertia associated with tendon velocity
    limited: mjtLimited;                         // does tendon have limits
    actfrclimited: mjtLimited;                   // does tendon have actuator force limits
    range: array[0..1] of Double;                // length limits
    actfrcrange: array[0..1] of Double;          // actuator force limits
    margin: Double;                              // margin value for tendon limit detection
    solref_limit: array[0..1] of mjtNum;         // solver reference: tendon limits
    solimp_limit: array[0..4] of mjtNum;         // solver impedance: tendon limits
    material: Pointer;                           // name of material for rendering
    width: Double;                               // width for rendering
    rgba: array[0..3] of Single;                 // rgba when material is omitted
    group: Int32;                                // group
    userdata: Pointer;                           // user data
    info: Pointer;                               // message appended to errors
  end;

  mjsWrap = record
    element: PmjsElement;                        // element type
    &type: mjtWrap;                              // wrap type
    info: Pointer;                               // message appended to errors
  end;

  mjsActuator = record
    element: PmjsElement;                        // element type
    &type: mjtActuator;                          // element the actuator is written with
    gaintype: mjtGain;                           // gain type
    gainprm: array[0..9] of Double;              // gain parameters
    biastype: mjtBias;                           // bias type
    biasprm: array[0..9] of Double;              // bias parameters
    dyntype: mjtDyn;                             // dynamics type
    dynprm: array[0..9] of Double;               // dynamics parameters
    actdim: Int32;                               // number of activation variables
    ctrlspec: Int32;                             // input signature, scoped by gaintype; 0: type default
    velrange: array[0..1] of Double;             // range of the velocity-setpoint input (pid)
    ffrange: array[0..1] of Double;              // range of the feedforward input (pid)
    actearly: mjtBool;                           // apply next activations to qfrc
    trntype: mjtTrn;                             // transmission type
    gear: array[0..5] of Double;                 // length and transmitted force scaling
    target: Pointer;                             // name of transmission target
    refsite: Pointer;                            // reference site, for site transmission
    slidersite: Pointer;                         // site defining cylinder, for slider-crank
    cranklength: Double;                         // crank length, for slider-crank
    lengthrange: array[0..1] of Double;          // transmission length range
    inheritrange: Double;                        // automatic range setting for position and intvelocity
    damping: array[0..2] of Double;              // damping coefficients
    armature: Double;                            // armature inertia
    ctrllimited: mjtLimited;                     // are control limits defined
    ctrlrange: array[0..1] of Double;            // control range
    forcelimited: mjtLimited;                    // are force limits defined
    forcerange: array[0..1] of Double;           // force range
    actlimited: mjtLimited;                      // are activation limits defined
    actrange: array[0..1] of Double;             // activation range
    group: Int32;                                // group
    nsample: Int32;                              // number of samples in history buffer
    interp: Int32;                               // interpolation order (0=ZOH, 1=linear, 2=cubic)
    delay: Double;                               // delay time in seconds; 0: no delay
    userdata: Pointer;                           // user data
    plugin: mjsPlugin;                           // actuator plugin
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsSensor = record
    element: PmjsElement;                        // element type
    &type: mjtSensor;                            // type of sensor
    objtype: mjtObj;                             // type of sensorized object
    objname: Pointer;                            // name of sensorized object
    reftype: mjtObj;                             // type of referenced object
    refname: Pointer;                            // name of referenced object
    intprm: array[0..2] of Int32;                // integer parameters
    datatype: mjtDataType;                       // data type for sensor measurement
    needstage: mjtStage;                         // compute stage needed to simulate sensor
    dim: Int32;                                  // number of scalar outputs
    cutoff: Double;                              // cutoff for real and positive datatypes
    noise: Double;                               // noise stdev
    nsample: Int32;                              // number of samples in history buffer
    interp: Int32;                               // interpolation order (0=ZOH, 1=linear, 2=cubic)
    delay: Double;                               // delay time in seconds
    interval: array[0..1] of Double;             // [period, time_prev] in seconds
    userdata: Pointer;                           // user data
    plugin: mjsPlugin;                           // sensor plugin
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsNumeric = record
    element: PmjsElement;                        // element type
    data: Pointer;                               // initialization data
    size: Int32;                                 // array size, can be bigger than data size
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsText = record
    element: PmjsElement;                        // element type
    data: Pointer;                               // text string
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsTuple = record
    element: PmjsElement;                        // element type
    objtype: Pointer;                            // object types
    objname: Pointer;                            // object names
    objprm: Pointer;                             // object parameters
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsKey = record
    element: PmjsElement;                        // element type
    time: Double;                                // time
    qpos: Pointer;                               // qpos
    qvel: Pointer;                               // qvel
    act: Pointer;                                // act
    mpos: Pointer;                               // mocap pos
    mquat: Pointer;                              // mocap quat
    ctrl: Pointer;                               // ctrl
    info: Pointer;                               // message appended to compiler errors
  end;

  mjsDefault = record
    element: PmjsElement;                        // element type
    joint: PmjsJoint;                            // joint defaults
    geom: PmjsGeom;                              // geom defaults
    site: PmjsSite;                              // site defaults
    camera: PmjsCamera;                          // camera defaults
    light: PmjsLight;                            // light defaults
    flex: PmjsFlex;                              // flex defaults
    mesh: PmjsMesh;                              // mesh defaults
    texture: PmjsTexture;                        // texture defaults
    material: PmjsMaterial;                      // material defaults
    pair: PmjsPair;                              // pair defaults
    equality: PmjsEquality;                      // equality defaults
    tendon: PmjsTendon;                          // tendon defaults
    actuator: PmjsActuator;                      // actuator defaults
  end;

  mjvPerturb = record
    select: Int32;                               // selected body id; non-positive: none
    flexselect: Int32;                           // selected flex id; negative: none
    skinselect: Int32;                           // selected skin id; negative: none
    active: Int32;                               // perturbation bitmask (mjtPertBit)
    active2: Int32;                              // secondary perturbation bitmask (mjtPertBit)
    refpos: array[0..2] of mjtNum;               // reference position for selected object
    refquat: array[0..3] of mjtNum;              // reference orientation for selected object
    refselpos: array[0..2] of mjtNum;            // reference position for selection point
    localpos: array[0..2] of mjtNum;             // selection point in object coordinates
    localmass: mjtNum;                           // spatial inertia at selection point
    scale: mjtNum;                               // relative mouse motion-to-space scaling (set by initPerturb)
  end;

  mjvCamera = record
    &type: Int32;                                // camera type (mjtCamera)
    fixedcamid: Int32;                           // fixed camera id
    trackbodyid: Int32;                          // body id to track
    lookat: array[0..2] of mjtNum;               // lookat point
    distance: mjtNum;                            // distance to lookat point or tracked body
    azimuth: mjtNum;                             // camera azimuth (deg)
    elevation: mjtNum;                           // camera elevation (deg)
    orthographic: Int32;                         // 0: perspective; 1: orthographic
  end;

  mjvGLCamera = record
    pos: array[0..2] of Single;                  // position
    forward: array[0..2] of Single;              // forward direction
    up: array[0..2] of Single;                   // up direction
    frustum_center: Single;                      // hor. center (left,right set to match aspect)
    frustum_width: Single;                       // width (not used for rendering)
    frustum_bottom: Single;                      // bottom
    frustum_top: Single;                         // top
    frustum_near: Single;                        // near
    frustum_far: Single;                         // far
    orthographic: Int32;                         // 0: perspective; 1: orthographic
  end;

  mjvGeom = record
    &type: Int32;                                // geom type (mjtGeom)
    dataid: Int32;                               // mesh, hfield or plane id; -1: none; mesh: 2*id or 2*id+1 (hull)
    objtype: Int32;                              // mujoco object type; mjOBJ_UNKNOWN for decor
    objid: Int32;                                // mujoco object id; -1 for decor
    category: Int32;                             // visual category
    matid: Int32;                                // material id; -1: no textured material
    texid: Int32;                                // texture id; -1: none
    texuniform: Int32;                           // uniform cube mapping
    texcoord: Int32;                             // mesh or flex geom has texture coordinates
    segid: Int32;                                // segmentation id; -1: not shown
    size: array[0..2] of Single;                 // size parameters
    pos: array[0..2] of Single;                  // Cartesian position
    mat: array[0..8] of Single;                  // Cartesian orientation
    rgba: array[0..3] of Single;                 // color and transparency
    emission: Single;                            // emission coef
    specular: Single;                            // specular coef
    shininess: Single;                           // shininess coef
    reflectance: Single;                         // reflectance coef
    texrepeat: array[0..1] of Single;            // texture repetition for 2d mapping
    &label: array[0..99] of AnsiChar;            // text label
    camdist: Single;                             // distance to camera (used by sorter)
    modelrbound: Single;                         // geom rbound from model, 0 if not model geom
    transparent: mjtByte;                        // treat geom as transparent
  end;

  mjvLight = record
    id: Int32;                                   // light id, -1 for headlight
    pos: array[0..2] of Single;                  // position rel. to body frame
    dir: array[0..2] of Single;                  // direction rel. to body frame
    &type: Int32;                                // type (mjtLightType)
    texid: Int32;                                // texture id for image lights
    attenuation: array[0..2] of Single;          // OpenGL attenuation (quadratic model)
    cutoff: Single;                              // OpenGL cutoff
    exponent: Single;                            // OpenGL exponent
    ambient: array[0..2] of Single;              // ambient rgb (alpha=1)
    diffuse: array[0..2] of Single;              // diffuse rgb (alpha=1)
    specular: array[0..2] of Single;             // specular rgb (alpha=1)
    headlight: mjtByte;                          // headlight
    castshadow: mjtByte;                         // does light cast shadows
    bulbradius: Single;                          // bulb radius for soft shadows
    intensity: Single;                           // intensity, in candelas
    range: Single;                               // range of effectiveness
    softness: Single;                            // spotlight edge softness
  end;

  mjvOption = record
    &label: Int32;                               // what objects to label (mjtLabel)
    frame: Int32;                                // which frame to show (mjtFrame)
    geomgroup: array[0..5] of mjtByte;           // geom visualization by group
    sitegroup: array[0..5] of mjtByte;           // site visualization by group
    jointgroup: array[0..5] of mjtByte;          // joint visualization by group
    tendongroup: array[0..5] of mjtByte;         // tendon visualization by group
    actuatorgroup: array[0..5] of mjtByte;       // actuator visualization by group
    flexgroup: array[0..5] of mjtByte;           // flex visualization by group
    skingroup: array[0..5] of mjtByte;           // skin visualization by group
    flags: array[0..30] of mjtByte;              // visualization flags (indexed by mjtVisFlag)
    bvh_depth: Int32;                            // depth of the bounding volume hierarchy to be visualized
    flex_layer: Int32;                           // element layer to be visualized for 3D flex
  end;

  mjvScene = record
    maxgeom: Int32;                              // size of allocated geom buffer
    ngeom: Int32;                                // number of geoms currently in buffer
    geoms: PmjvGeom;                             // buffer for geoms (ngeom)
    geomorder: PmjInt32;                         // buffer for ordering geoms by distance to camera (ngeom)
    nflex: Int32;                                // number of flexes
    flexedgeadr: PmjInt32;                       // address of flex edges (nflex)
    flexedgenum: PmjInt32;                       // number of edges in flex (nflex)
    flexvertadr: PmjInt32;                       // address of flex vertices (nflex)
    flexvertnum: PmjInt32;                       // number of vertices in flex (nflex)
    flexfaceadr: PmjInt32;                       // address of flex faces (nflex)
    flexfacenum: PmjInt32;                       // number of flex faces allocated (nflex)
    flexfaceused: PmjInt32;                      // number of flex faces currently in use (nflex)
    flexedge: PmjInt32;                          // flex edge data (2*nflexedge)
    flexvert: PmjSingle;                         // flex vertices (3*nflexvert)
    flexface: PmjSingle;                         // flex faces vertices (9*sum(flexfacenum))
    flexnormal: PmjSingle;                       // flex face normals (9*sum(flexfacenum))
    flextexcoord: PmjSingle;                     // flex face texture coordinates (6*sum(flexfacenum))
    flexvertopt: mjtByte;                        // copy of mjVIS_FLEXVERT mjvOption flag
    flexedgeopt: mjtByte;                        // copy of mjVIS_FLEXEDGE mjvOption flag
    flexfaceopt: mjtByte;                        // copy of mjVIS_FLEXFACE mjvOption flag
    flexskinopt: mjtByte;                        // copy of mjVIS_FLEXSKIN mjvOption flag
    nskin: Int32;                                // number of skins
    skinfacenum: PmjInt32;                       // number of faces in skin (nskin)
    skinvertadr: PmjInt32;                       // address of skin vertices (nskin)
    skinvertnum: PmjInt32;                       // number of vertices in skin (nskin)
    skinvert: PmjSingle;                         // skin vertex data (3*nskinvert)
    skinnormal: PmjSingle;                       // skin normal data (3*nskinvert)
    nlight: Int32;                               // number of lights currently in buffer
    lights: array[0..99] of mjvLight;            // buffer for lights (nlight)
    camera: array[0..1] of mjvGLCamera;          // left and right camera
    enabletransform: mjtByte;                    // enable model transformation
    translate: array[0..2] of Single;            // model translation
    rotate: array[0..3] of Single;               // model quaternion rotation
    scale: Single;                               // model scaling
    stereo: Int32;                               // stereoscopic rendering (mjtStereo)
    flags: array[0..10] of mjtByte;              // rendering flags (indexed by mjtRndFlag)
    framewidth: Int32;                           // frame pixel width; 0: disable framing
    framergb: array[0..2] of Single;             // frame color
    status: Int32;                               // 0: ok, 1: geoms exhausted, warning issued
  end;

  mjvFigure = record
    flg_legend: Int32;                           // show legend
    flg_ticklabel: array[0..1] of Int32;         // show grid tick labels (x,y)
    flg_extend: Int32;                           // automatically extend axis ranges to fit data
    flg_barplot: Int32;                          // isolated line segments (i.e. GL_LINES)
    flg_selection: Int32;                        // vertical selection line
    flg_symmetric: Int32;                        // symmetric y-axis
    linewidth: Single;                           // line width
    gridwidth: Single;                           // grid line width
    gridsize: array[0..1] of Int32;              // number of grid points in (x,y)
    gridrgb: array[0..2] of Single;              // grid line rgb
    figurergba: array[0..3] of Single;           // figure color and alpha
    panergba: array[0..3] of Single;             // pane color and alpha
    legendrgba: array[0..3] of Single;           // legend color and alpha
    textrgb: array[0..2] of Single;              // text color
    linergb: array[0..99, 0..2] of Single;       // line colors
    range: array[0..1, 0..1] of Single;          // axis ranges; (min>=max) automatic
    xformat: array[0..19] of AnsiChar;           // x-tick label format for sprintf
    yformat: array[0..19] of AnsiChar;           // y-tick label format for sprintf
    minwidth: array[0..19] of AnsiChar;          // string used to determine min y-tick width
    title: array[0..999] of AnsiChar;            // figure title; subplots separated with 2+ spaces
    xlabel: array[0..99] of AnsiChar;            // x-axis label
    linename: array[0..99, 0..99] of AnsiChar;   // line names for legend
    legendoffset: Int32;                         // number of lines to offset legend
    subplot: Int32;                              // selected subplot (for title rendering)
    highlight: array[0..1] of Int32;             // if point is in legend rect, highlight line
    highlightid: Int32;                          // if id>=0 and no point, highlight id
    selection: Single;                           // selection line x-value
    linepnt: array[0..99] of Int32;              // number of points in line; (0) disable
    linedata: array[0..99, 0..2001] of Single;   // line data (x,y)
    xaxispixel: array[0..1] of Int32;            // range of x-axis in pixels
    yaxispixel: array[0..1] of Int32;            // range of y-axis in pixels
    xaxisdata: array[0..1] of Single;            // range of x-axis in data units
    yaxisdata: array[0..1] of Single;            // range of y-axis in data units
  end;

  mjSDF = record
    plugin: PPmjpPlugin;
    id: PmjInt32;
    &type: mjtSDFType;
    relpos: PmjtNum;
    relmat: PmjtNum;
    geomtype: PmjtGeom;
  end;

  mjrRect = record
    left: Int32;                                 // left (usually 0)
    bottom: Int32;                               // bottom (usually 0)
    width: Int32;                                // width (usually buffer width)
    height: Int32;                               // height (usually buffer height)
  end;

  mjrRendererInfo = record
    renderer: PAnsiChar;                         // renderer family: classic, filament, noop
    backend: PAnsiChar;                          // graphics backend: opengl, vulkan; empty if uninitialized
  end;

  mjrVertexAttribute = record
    usage: Int32;                                // position, normal, etc [mjrVertexAttributeUsage]
    &type: Int32;                                // float3, ubyte4, etc. [mjrVertexAttributeType]
  end;

  mjrContext = record
    lineWidth: Single;                           // line width for wireframe rendering
    shadowClip: Single;                          // clipping radius for directional lights
    shadowScale: Single;                         // fraction of light cutoff for spot lights
    fogStart: Single;                            // fog start = stat.extent * vis.map.fogstart
    fogEnd: Single;                              // fog end = stat.extent * vis.map.fogend
    fogRGBA: array[0..3] of Single;              // fog rgba
    shadowSize: Int32;                           // size of shadow map texture
    offWidth: Int32;                             // width of offscreen buffer
    offHeight: Int32;                            // height of offscreen buffer
    offSamples: Int32;                           // number of offscreen buffer multisamples
    fontScale: Int32;                            // font scale
    auxWidth: array[0..9] of Int32;              // auxiliary buffer width
    auxHeight: array[0..9] of Int32;             // auxiliary buffer height
    auxSamples: array[0..9] of Int32;            // auxiliary buffer multisamples
    offFBO: UInt32;                              // offscreen framebuffer object
    offFBO_r: UInt32;                            // offscreen framebuffer for resolving multisamples
    offColor: UInt32;                            // offscreen color buffer
    offColor_r: UInt32;                          // offscreen color buffer for resolving multisamples
    offDepthStencil: UInt32;                     // offscreen depth and stencil buffer
    offDepthStencil_r: UInt32;                   // offscreen depth and stencil buffer for multisamples
    shadowFBO: UInt32;                           // shadow map framebuffer object
    shadowTex: UInt32;                           // shadow map texture
    auxFBO: array[0..9] of UInt32;               // auxiliary framebuffer object
    auxFBO_r: array[0..9] of UInt32;             // auxiliary framebuffer object for resolving
    auxColor: array[0..9] of UInt32;             // auxiliary color buffer
    auxColor_r: array[0..9] of UInt32;           // auxiliary color buffer for resolving
    mat_texid: array[0..9999] of Int32;          // material texture ids (-1: no texture)
    mat_texuniform: array[0..999] of Int32;      // uniform cube mapping
    mat_texrepeat: array[0..1999] of Single;     // texture repetition for 2d mapping
    ntexture: Int32;                             // number of allocated textures
    textureType: array[0..999] of Int32;         // type of texture (mjtTexture) (ntexture)
    texture: array[0..999] of UInt32;            // texture names
    basePlane: UInt32;                           // all planes from model
    baseMesh: UInt32;                            // all meshes from model
    baseHField: UInt32;                          // all height fields from model
    baseBuiltin: UInt32;                         // all builtin geoms, with quality from model
    baseFontNormal: UInt32;                      // normal font
    baseFontShadow: UInt32;                      // shadow font
    baseFontBig: UInt32;                         // big font
    rangePlane: Int32;                           // all planes from model
    rangeMesh: Int32;                            // all meshes from model
    rangeHField: Int32;                          // all hfields from model
    rangeBuiltin: Int32;                         // all builtin geoms, with quality from model
    rangeFont: Int32;                            // all characters in font
    nskin: Int32;                                // number of skins
    skinvertVBO: PmjUInt32;                      // skin vertex position VBOs (nskin)
    skinnormalVBO: PmjUInt32;                    // skin vertex normal VBOs (nskin)
    skintexcoordVBO: PmjUInt32;                  // skin vertex texture coordinate VBOs (nskin)
    skinfaceVBO: PmjUInt32;                      // skin face index VBOs (nskin)
    charWidth: array[0..126] of Int32;           // character widths: normal and shadow
    charWidthBig: array[0..126] of Int32;        // character widths: big
    charHeight: Int32;                           // character heights: normal and shadow
    charHeightBig: Int32;                        // character heights: big
    glInitialized: Int32;                        // is OpenGL initialized
    windowAvailable: Int32;                      // is default/window framebuffer available
    windowSamples: Int32;                        // number of samples for default/window framebuffer
    windowStereo: Int32;                         // is stereo available for default/window framebuffer
    windowDoublebuffer: Int32;                   // is default/window framebuffer double buffered
    currentBuffer: Int32;                        // currently active framebuffer: mjFB_WINDOW or mjFB_OFFSCREEN
    readPixelFormat: Int32;                      // default color pixel format for mjr_readPixels
    readDepthMap: Int32;                         // depth mapping: mjDEPTH_ZERONEAR or mjDEPTH_ZEROFAR
  end;

  //---------------------------------------------------------------------------
  // records from mjplugin.h and mjbatch.h

  mjResource = record
    name: PAnsiChar;                             // name of resource (filename, etc)
    data: Pointer;                               // opaque data pointer
    vfs: PmjVFS;                                 // pointer to the VFS
    timestamp: array[0..511] of AnsiChar;        // timestamp of the resource
    provider: PmjpResourceProvider;              // pointer to the provider
    args: PAnsiChar;                             // resource arguments/hints, URI query format key=val&...
  end;

  mjpResourceProvider = record
    prefix: PAnsiChar;                           // prefix for match against a resource name
    open: mjfOpenResource;                       // opening callback
    read: mjfReadResource;                       // reading callback
    close: mjfCloseResource;                     // closing callback
    mount: mjfMountResource;                     // mounting callback (optional)
    unmount: mjfUnmountResource;                 // unmounting callback (optional)
    modified: mjfResourceModified;               // resource modified callback (optional)
    write: mjfWriteResource;                     // writing callback (optional)
    data: Pointer;                               // opaque data pointer (resource invariant)
  end;

  mjpDecoder = record
    content_type: PAnsiChar;
    extension: PAnsiChar;
    can_decode: mjfCanDecode;                    // quickly check if this decoder can handle the resource
    decode: mjfDecode;                           // main decoding function; caller owns the returned spec
  end;

  mjpEncoder = record
    content_type: PAnsiChar;
    extension: PAnsiChar;
    encode: mjfEncode;                           // encode an mjSpec and mjModel to a mjResource
    close_resource: mjfCloseResource;            // close/free the resource
  end;

  mjpPlugin = record
    name: PAnsiChar;                             // globally unique name identifying the plugin
    nattribute: Int32;                           // number of configuration attributes
    attributes: PPAnsiChar;                      // name of configuration attributes
    capabilityflags: Int32;                      // plugin capabilities: bitfield of mjtPluginCapabilityBit
    needstage: Int32;                            // sensor computation stage (mjtStage)
    nstate: mjpPlugin_nstate;                    // number of mjtNums of plugin instance state (required)
    nsensordata: mjpPlugin_nsensordata;          // dimension of a sensor's output (sensor plugins)
    init: mjpPlugin_init;                        // new mjData created (required); 0 on success, -1 on failure
    destroy: mjpPlugin_destroy;                  // mjData being freed (optional)
    copy: mjpPlugin_copy;                        // mjData being copied (optional)
    reset: mjpPlugin_reset;                      // mjData being reset (required)
    compute: mjpPlugin_compute;                  // update outputs (required)
    advance: mjpPlugin_advance;                  // time integration (optional)
    visualize: mjpPlugin_visualize;              // called by mjv_updateScene (optional)
    actuator_act_dot: mjpPlugin_actuator_act_dot; // actuator plugin act_dot (optional)
    sdf_distance: mjpPlugin_sdf_distance;        // SDF: signed distance from the surface
    sdf_gradient: mjpPlugin_sdf_gradient;        // SDF: gradient w.r.t. local coordinates
    sdf_staticdistance: mjpPlugin_sdf_staticdistance; // SDF: distance used for marching cubes
    sdf_attribute: mjpPlugin_sdf_attribute;      // SDF: convert attributes, provide defaults
    sdf_aabb: mjpPlugin_sdf_aabb;                // SDF: bounding box of implicit surface
  end;

  mjBatchConfig = record                         // parameters of mjb_makeBatch
    nthread: Int32;                              // threads including the caller's; <= 0: one per logical CPU
    persistent: mjtBool;                         // one mjData per simulation instead of one per thread
  end;

  mjBatchRecord = record                         // mjData field or state recorded by mjb_rollout
    field: PAnsiChar;                            // mjData field (as for mjb_output), nil: record a state
    spec: Int32;                                 // mjtState bits of the recorded state
    buf: Pointer;                                // output (n x nstep x size), of the field's type
  end;

  //---------------------------------------------------------------------------
  // library variable types

  Tmju_user_malloc = function(size: NativeUInt): Pointer; cdecl;
  Tmju_user_free = procedure(ptr: Pointer); cdecl;
  Tmju_user_message = procedure(msg: PAnsiChar); cdecl;
  TmjCollisionTable = array[0..mjNGEOMTYPES - 1, 0..mjNGEOMTYPES - 1] of mjfCollision;
  TmjDisableStrings = array[0..mjNDISABLE - 1] of PAnsiChar;
  TmjEnableStrings = array[0..mjNENABLE - 1] of PAnsiChar;
  TmjTimerStrings = array[0..mjNTIMER - 1] of PAnsiChar;
  TmjLabelStrings = array[0..mjNLABEL - 1] of PAnsiChar;
  TmjFrameStrings = array[0..mjNFRAME - 1] of PAnsiChar;
  TmjVisStrings = array[0..mjNVISFLAG - 1, 0..2] of PAnsiChar;
  TmjRndStrings = array[0..mjNRNDFLAG - 1, 0..2] of PAnsiChar;
  TmjTopicStrings = array[0..mjNTOPIC - 1] of PAnsiChar;

  //---------------------------------------------------------------------------
  // API function types

  // Initialize an empty VFS, mj_deleteVFS must be called to deallocate the VFS.
  Tmj_defaultVFS = procedure(vfs: PmjVFS); cdecl;
  // Mount a provider to handle file operations under the given path; return 0: success, 2: repeated name, -1: invalid provider.
  Tmj_mountVFS = function(vfs: PmjVFS; filepath: PAnsiChar; provider: PmjpResourceProvider): Int32; cdecl;
  // Unmount a previously mounted provider; return 0: success, -1: not found in VFS.
  Tmj_unmountVFS = function(vfs: PmjVFS; filename: PAnsiChar): Int32; cdecl;
  // Add file to VFS; return 0: success, 2: repeated name, -1: failed to load.
  Tmj_addFileVFS = function(vfs: PmjVFS; directory: PAnsiChar; filename: PAnsiChar): Int32; cdecl;
  // Add file to VFS from buffer; return 0: success, 2: repeated name, -1: failed to load.
  Tmj_addBufferVFS = function(vfs: PmjVFS; name: PAnsiChar; buffer: Pointer; nbuffer: Int32): Int32; cdecl;
  // Delete file from VFS; return 0: success, -1: not found in VFS.
  Tmj_deleteFileVFS = function(vfs: PmjVFS; filename: PAnsiChar): Int32; cdecl;
  // Check if buffer exists in VFS; return 1: exists, 0: not found.
  Tmj_containsBufferVFS = function(vfs: PmjVFS; name: PAnsiChar): Int32; cdecl;
  // Check if file exists in VFS; return 1: exists, 0: not found.
  Tmj_containsFileVFS = function(vfs: PmjVFS; directory: PAnsiChar; filename: PAnsiChar): Int32; cdecl;
  // Delete all files from VFS and deallocates VFS internal memory.
  Tmj_deleteVFS = procedure(vfs: PmjVFS); cdecl;
  // Get the current size of the asset cache in bytes.
  Tmj_getCacheSize = function(cache: PmjCache): NativeUInt; cdecl;
  // Get the capacity of the asset cache in bytes.
  Tmj_getCacheCapacity = function(cache: PmjCache): NativeUInt; cdecl;
  // Set the capacity of the asset cache in bytes (0 to disable); return the new capacity.
  Tmj_setCacheCapacity = function(cache: PmjCache; size: NativeUInt): NativeUInt; cdecl;
  // Get the internal asset cache used by the compiler.
  Tmj_getCache = function: PmjCache; cdecl;
  // Clear the asset cache.
  Tmj_clearCache = procedure(cache: PmjCache); cdecl;
  // Parse XML file in MJCF or URDF format, compile it; return low-level model. If vfs is not NULL, look up files in vfs before reading from disk. If error is not NULL, it must have size error_sz.
  Tmj_loadXML = function(filename: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): PmjModel; cdecl;
  // Parse spec from XML file.
  Tmj_parseXML = function(filename: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): PmjSpec; cdecl;
  // Parse spec from XML string.
  Tmj_parseXMLString = function(xml: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): PmjSpec; cdecl;
  // Parse spec from a file.
  Tmj_parse = function(filename: PAnsiChar; content_type: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): PmjSpec; cdecl;
  // Encode spec/model to a file using a registered encoder. Returns the number of bytes written on success, -1 on failure.
  Tmj_encode = function(s: PmjSpec; m: PmjModel; filename: PAnsiChar; content_type: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): mjtSize; cdecl;
  // Compile spec to model.
  Tmj_compile = function(s: PmjSpec; vfs: PmjVFS): PmjModel; cdecl;
  // Copy the values which were changed in a model to the spec it was compiled from; return 1 on success.
  Tmj_copyBack = function(s: PmjSpec; m: PmjModel): Int32; cdecl;
  // Recompile spec to model, preserving the state; return 0 on success.
  Tmj_recompile = function(s: PmjSpec; vfs: PmjVFS; m: PmjModel; d: PmjData): Int32; cdecl;
  // Decode texture id to raw bytes, exactly what compilation would store in tex_data, with tex_nchannel channels; embedded textures are copied from the model. The buffer is allocated with mju_malloc and freed by the caller; colorspace receives the resolved colorspace (mjtColorSpace). Return 0 on success.
  Tmj_loadTexture = function(m: PmjModel; id: Int32; data: PPmjtByte; width: PmjInt32; height: PmjInt32; colorspace: PmjInt32; error: PAnsiChar; error_sz: Int32): Int32; cdecl;
  // Copy of m with every by-reference asset loaded into it, as compilation would have stored it. Return NULL with error on a file that does not resolve. A hermetic MJB file of a model with by-reference assets is mj_embedAssets, then mj_saveModel, then mj_deleteModel.
  Tmj_embedAssets = function(m: PmjModel; error: PAnsiChar; error_sz: Int32): PmjModel; cdecl;
  // Update XML data structures with info from low-level model created with mj_loadXML, save as MJCF. If error is not NULL, it must have size error_sz.
  Tmj_saveLastXML = function(filename: PAnsiChar; m: PmjModel; error: PAnsiChar; error_sz: Int32): Int32; cdecl;
  // Free last XML model if loaded. Called internally at each load.
  Tmj_freeLastXML = procedure; cdecl;
  // Save spec to XML string; return 0 on success, -1 on failure. If length of the output buffer is too small; return the required size.
  Tmj_saveXMLString = function(s: PmjSpec; xml: PAnsiChar; xml_sz: Int32; error: PAnsiChar; error_sz: Int32): Int32; cdecl;
  // Save spec to XML file; return 0 on success, -1 otherwise.
  Tmj_saveXML = function(s: PmjSpec; filename: PAnsiChar; error: PAnsiChar; error_sz: Int32): Int32; cdecl;
  // Given MJCF filename, fills dependencies with a list of all other asset files it depends on. The search is recursive, and the list includes the filename itself.
  Tmju_getXMLDependencies = procedure(filename: PAnsiChar; dependencies: Pointer); cdecl;
  // Advance simulation, use control callback to obtain external force and control.
  Tmj_step = procedure(m: PmjModel; d: PmjData); cdecl;
  // Advance simulation in two steps: before external force and control is set by user.
  Tmj_step1 = procedure(m: PmjModel; d: PmjData); cdecl;
  // Advance simulation in two steps: after external force and control is set by user.
  Tmj_step2 = procedure(m: PmjModel; d: PmjData); cdecl;
  // Forward dynamics: same as mj_step but do not integrate in time.
  Tmj_forward = procedure(m: PmjModel; d: PmjData); cdecl;
  // Inverse dynamics: qacc must be set before calling.
  Tmj_inverse = procedure(m: PmjModel; d: PmjData); cdecl;
  // Forward dynamics with skip; skipstage is mjtStage.
  Tmj_forwardSkip = procedure(m: PmjModel; d: PmjData; skipstage: Int32; skipsensor: Int32); cdecl;
  // Inverse dynamics with skip; skipstage is mjtStage.
  Tmj_inverseSkip = procedure(m: PmjModel; d: PmjData; skipstage: Int32; skipsensor: Int32); cdecl;
  // Set default options for length range computation.
  Tmj_defaultLROpt = procedure(opt: PmjLROpt); cdecl;
  // Set solver parameters to default values.
  Tmj_defaultSolRefImp = procedure(solref: PmjtNum; solimp: PmjtNum); cdecl;
  // Set physics options to default values.
  Tmj_defaultOption = procedure(opt: PmjOption); cdecl;
  // Set visual options to default values.
  Tmj_defaultVisual = procedure(vis: PmjVisual); cdecl;
  // Copy mjModel, allocate new if dest is NULL.
  Tmj_copyModel = function(dest: PmjModel; src: PmjModel): PmjModel; cdecl;
  // Save model to binary MJB file or memory buffer; buffer has precedence when given.
  Tmj_saveModel = procedure(m: PmjModel; filename: PAnsiChar; buffer: Pointer; buffer_sz: mjtSize); cdecl;
  // Load model from binary MJB file. If vfs is not NULL, look up file in vfs before reading from disk.
  Tmj_loadModel = function(filename: PAnsiChar; vfs: PmjVFS): PmjModel; cdecl;
  // Load model from memory buffer.
  Tmj_loadModelBuffer = function(buffer: Pointer; buffer_sz: mjtSize): PmjModel; cdecl;
  // Free memory allocation in model.
  Tmj_deleteModel = procedure(m: PmjModel); cdecl;
  // Return size of buffer needed to hold model.
  Tmj_sizeModel = function(m: PmjModel): mjtSize; cdecl;
  // Allocate mjData corresponding to given model. If the model buffer is unallocated the initial configuration will not be set.
  Tmj_makeData = function(m: PmjModel): PmjData; cdecl;
  // Copy mjData. m is only required to contain the size fields from MJMODEL_INTS.
  Tmj_copyData = function(dest: PmjData; m: PmjModel; src: PmjData): PmjData; cdecl;
  // Copy mjData, skip large arrays not required for visualization.
  Tmjv_copyData = function(dest: PmjData; m: PmjModel; src: PmjData): PmjData; cdecl;
  // Reset ctrl to neutral values: zero, except quaternion inputs which reset to the identity.
  Tmj_resetCtrl = procedure(m: PmjModel; d: PmjData); cdecl;
  // Reset data to defaults.
  Tmj_resetData = procedure(m: PmjModel; d: PmjData); cdecl;
  // Reset data to defaults, fill everything else with debug_value.
  Tmj_resetDataDebug = procedure(m: PmjModel; d: PmjData; debug_value: Byte); cdecl;
  // Reset data. If 0 <= key < nkey, set fields from specified keyframe.
  Tmj_resetDataKeyframe = procedure(m: PmjModel; d: PmjData; key: Int32); cdecl;
  // Mark a new frame on the mjData stack.
  Tmj_markStack = procedure(d: PmjData); cdecl;
  // Free the current mjData stack frame. All pointers returned by mj_stackAlloc since the last call to mj_markStack must no longer be used afterwards.
  Tmj_freeStack = procedure(d: PmjData); cdecl;
  // Allocate a number of bytes on mjData stack at a specific alignment. Call mju_error on stack overflow.
  Tmj_stackAllocByte = function(d: PmjData; bytes: NativeUInt; alignment: NativeUInt): Pointer; cdecl;
  // Allocate array of mjtNums on mjData stack. Call mju_error on stack overflow.
  Tmj_stackAllocNum = function(d: PmjData; size: NativeUInt): PmjtNum; cdecl;
  // Allocate array of ints on mjData stack. Call mju_error on stack overflow.
  Tmj_stackAllocInt = function(d: PmjData; size: NativeUInt): PmjInt32; cdecl;
  // Free memory allocation in mjData.
  Tmj_deleteData = procedure(d: PmjData); cdecl;
  // Reset all callbacks to NULL pointers (NULL is the default).
  Tmj_resetCallbacks = procedure; cdecl;
  // Set constant fields of mjModel, corresponding to qpos0 configuration.
  Tmj_setConst = procedure(m: PmjModel; d: PmjData); cdecl;
  // Set actuator_lengthrange for specified actuator; return 1 if ok, 0 if error.
  Tmj_setLengthRange = function(m: PmjModel; d: PmjData; index: Int32; opt: PmjLROpt; error: PAnsiChar; error_sz: Int32): Int32; cdecl;
  // Create empty spec.
  Tmj_makeSpec = function: PmjSpec; cdecl;
  // Copy spec.
  Tmj_copySpec = function(s: PmjSpec): PmjSpec; cdecl;
  // Free memory allocation in mjSpec.
  Tmj_deleteSpec = procedure(s: PmjSpec); cdecl;
  // Activate plugin; return 0 on success.
  Tmjs_activatePlugin = function(s: PmjSpec; name: PAnsiChar): Int32; cdecl;
  // Turn deep copy on or off attach; return 0 on success.
  Tmjs_setDeepCopy = function(s: PmjSpec; deepcopy: Int32): Int32; cdecl;
  // Print mjModel to text file, specifying format. float_format must be a valid printf-style format string for a single float value.
  Tmj_printFormattedModel = procedure(m: PmjModel; filename: PAnsiChar; float_format: PAnsiChar); cdecl;
  // Print model to text file.
  Tmj_printModel = procedure(m: PmjModel; filename: PAnsiChar); cdecl;
  // Print mjData to text file, specifying format. float_format must be a valid printf-style format string for a single float value.
  Tmj_printFormattedData = procedure(m: PmjModel; d: PmjData; filename: PAnsiChar; float_format: PAnsiChar); cdecl;
  // Print data to text file.
  Tmj_printData = procedure(m: PmjModel; d: PmjData; filename: PAnsiChar); cdecl;
  // Print matrix to screen.
  Tmju_printMat = procedure(mat: PmjtNum; nr: Int32; nc: Int32); cdecl;
  // Print sparse matrix to screen.
  Tmju_printMatSparse = procedure(mat: PmjtNum; nr: Int32; rownnz: PmjInt32; rowadr: PmjInt32; colind: PmjInt32); cdecl;
  // Print internal XML schema as plain text or HTML, with style-padding or &nbsp;.
  Tmj_printSchema = function(filename: PAnsiChar; buffer: PAnsiChar; buffer_sz: Int32; flg_html: Int32; flg_pad: Int32): Int32; cdecl;
  // Print scene to text file.
  Tmj_printScene = procedure(s: PmjvScene; filename: PAnsiChar); cdecl;
  // Print scene to text file, specifying format. float_format must be a valid printf-style format string for a single float value.
  Tmj_printFormattedScene = procedure(s: PmjvScene; filename: PAnsiChar; float_format: PAnsiChar); cdecl;
  // Run all kinematics-like computations (kinematics, comPos, camlight, flex, tendon).
  Tmj_fwdKinematics = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run position-dependent computations.
  Tmj_fwdPosition = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run velocity-dependent computations.
  Tmj_fwdVelocity = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute actuator force qfrc_actuator.
  Tmj_fwdActuation = procedure(m: PmjModel; d: PmjData); cdecl;
  // Add up all non-constraint forces, compute qacc_smooth.
  Tmj_fwdAcceleration = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run selected constraint solver.
  Tmj_fwdConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Euler integrator, semi-implicit in velocity.
  Tmj_Euler = procedure(m: PmjModel; d: PmjData); cdecl;
  // Runge-Kutta explicit order-N integrator.
  Tmj_RungeKutta = procedure(m: PmjModel; d: PmjData; N: Int32); cdecl;
  // Implicit-in-velocity integrators.
  Tmj_implicit = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run position-dependent computations in inverse dynamics.
  Tmj_invPosition = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run velocity-dependent computations in inverse dynamics.
  Tmj_invVelocity = procedure(m: PmjModel; d: PmjData); cdecl;
  // Apply the analytical formula for inverse constraint dynamics.
  Tmj_invConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compare forward and inverse dynamics, save results in fwdinv.
  Tmj_compareFwdInv = procedure(m: PmjModel; d: PmjData); cdecl;
  // Evaluate position-dependent sensors.
  Tmj_sensorPos = procedure(m: PmjModel; d: PmjData); cdecl;
  // Evaluate velocity-dependent sensors.
  Tmj_sensorVel = procedure(m: PmjModel; d: PmjData); cdecl;
  // Evaluate acceleration and force-dependent sensors.
  Tmj_sensorAcc = procedure(m: PmjModel; d: PmjData); cdecl;
  // Evaluate position-dependent energy (potential).
  Tmj_energyPos = procedure(m: PmjModel; d: PmjData); cdecl;
  // Evaluate velocity-dependent energy (kinetic).
  Tmj_energyVel = procedure(m: PmjModel; d: PmjData); cdecl;
  // Check qpos, reset if any element is too big or nan.
  Tmj_checkPos = procedure(m: PmjModel; d: PmjData); cdecl;
  // Check qvel, reset if any element is too big or nan.
  Tmj_checkVel = procedure(m: PmjModel; d: PmjData); cdecl;
  // Check qacc, reset if any element is too big or nan.
  Tmj_checkAcc = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run forward kinematics.
  Tmj_kinematics = procedure(m: PmjModel; d: PmjData); cdecl;
  // Map inertias and motion dofs to global frame centered at CoM.
  Tmj_comPos = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute camera and light positions and orientations.
  Tmj_camlight = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute flex-related quantities.
  Tmj_flex = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute tendon lengths, velocities and moment arms.
  Tmj_tendon = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute actuator transmission lengths and moments.
  Tmj_transmission = procedure(m: PmjModel; d: PmjData); cdecl;
  // Run composite rigid body inertia algorithm (CRB).
  Tmj_crb = procedure(m: PmjModel; d: PmjData); cdecl;
  // Make inertia matrix.
  Tmj_makeM = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute sparse L'*D*L factorizaton of inertia matrix.
  Tmj_factorM = procedure(m: PmjModel; d: PmjData); cdecl;
  // Solve linear system M * x = y using factorization:  x = inv(L'*D*L)*y
  Tmj_solveM = procedure(m: PmjModel; d: PmjData; x: PmjtNum; y: PmjtNum; n: Int32); cdecl;
  // Half of linear solve:  x = sqrt(inv(D))*inv(L')*y
  Tmj_solveM2 = procedure(m: PmjModel; d: PmjData; x: PmjtNum; y: PmjtNum; sqrtInvD: PmjtNum; n: Int32); cdecl;
  // Compute cvel, cdof_dot.
  Tmj_comVel = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute qfrc_passive from spring-dampers, gravity compensation and fluid forces.
  Tmj_passive = procedure(m: PmjModel; d: PmjData); cdecl;
  // Sub-tree linear velocity and angular momentum: compute subtree_linvel, subtree_angmom.
  Tmj_subtreeVel = procedure(m: PmjModel; d: PmjData); cdecl;
  // RNE: compute M(qpos)*qacc + C(qpos,qvel); flg_acc=0 removes inertial term.
  Tmj_rne = procedure(m: PmjModel; d: PmjData; flg_acc: Int32; result: PmjtNum); cdecl;
  // RNE with complete data: compute cacc, cfrc_ext, cfrc_int.
  Tmj_rnePostConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Return the maximum number of contacts that can be generated between two geoms. If has_margin is -1, then the margin is pulled from the model, otherwise if has_margin > 0 indicates that the geoms have a positive margin.
  Tmj_maxContact = function(m: PmjModel; g1: Int32; g2: Int32; has_margin: Int32): Int32; cdecl;
  // Run collision detection.
  Tmj_collision = procedure(m: PmjModel; d: PmjData); cdecl;
  // Construct constraints.
  Tmj_makeConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Find constraint islands.
  Tmj_island = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute inverse constraint inertia efc_AR.
  Tmj_projectConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute efc_vel, efc_aref.
  Tmj_referenceConstraint = procedure(m: PmjModel; d: PmjData); cdecl;
  // Compute efc_state, efc_force, qfrc_constraint, and (optionally) cone Hessians. If cost is not NULL, set *cost = s(jar) where jar = Jac*qacc-aref.
  Tmj_constraintUpdate = procedure(m: PmjModel; d: PmjData; jar: PmjtNum; cost: PmjtNum; flg_coneHessian: Int32); cdecl;
  // Return size of state signature.
  Tmj_stateSize = function(m: PmjModel; sig: Int32): Int32; cdecl;
  // Get state.
  Tmj_getState = procedure(m: PmjModel; d: PmjData; state: PmjtNum; sig: Int32); cdecl;
  // Extract a subset of components from a state previously obtained via mj_getState.
  Tmj_extractState = procedure(m: PmjModel; src: PmjtNum; srcsig: Int32; dst: PmjtNum; dstsig: Int32); cdecl;
  // Set state.
  Tmj_setState = procedure(m: PmjModel; d: PmjData; state: PmjtNum; sig: Int32); cdecl;
  // Copy state from src to dst.
  Tmj_copyState = procedure(m: PmjModel; src: PmjData; dst: PmjData; sig: Int32); cdecl;
  // Read ctrl value for actuator at given time. Returns pointer to ctrl (no history) or history buffer (exact match), or NULL if interpolation performed (writes to result). interp: 0=zero-order-hold, 1=linear, 2=cubic spline.
  Tmj_readCtrl = function(m: PmjModel; d: PmjData; id: Int32; time: mjtNum; result: PmjtNum; interp: Int32): PmjtNum; cdecl;
  // Read sensor value from history buffer at given time. Returns pointer to sensordata (no history) or history buffer (exact match), or NULL if interpolation performed (writes to result). interp: 0=zero-order-hold, 1=linear, 2=cubic spline.
  Tmj_readSensor = function(m: PmjModel; d: PmjData; id: Int32; time: mjtNum; result: PmjtNum; interp: Int32): PmjtNum; cdecl;
  // Initialize history buffer for actuator; if times is NULL, uses existing buffer timestamps.
  Tmj_initCtrlHistory = procedure(m: PmjModel; d: PmjData; id: Int32; times: PmjtNum; values: PmjtNum); cdecl;
  // Initialize history buffer for sensor; if times is NULL, uses existing buffer timestamps. phase sets the user slot (last computation time for interval sensors).
  Tmj_initSensorHistory = procedure(m: PmjModel; d: PmjData; id: Int32; times: PmjtNum; values: PmjtNum; phase: mjtNum); cdecl;
  // Copy current state to the k-th model keyframe.
  Tmj_setKeyframe = procedure(m: PmjModel; d: PmjData; k: Int32); cdecl;
  // Add contact to d->contact list; return 0 if success; 1 if buffer full.
  Tmj_addContact = function(m: PmjModel; d: PmjData; con: PmjContact): Int32; cdecl;
  // Determine type of friction cone.
  Tmj_isPyramidal = function(m: PmjModel): Int32; cdecl;
  // Determine type of constraint Jacobian.
  Tmj_isSparse = function(m: PmjModel): Int32; cdecl;
  // Determine type of solver (PGS is dual, CG and Newton are primal).
  Tmj_isDual = function(m: PmjModel): Int32; cdecl;
  // Multiply dense or sparse constraint Jacobian by vector.
  Tmj_mulJacVec = procedure(m: PmjModel; d: PmjData; res: PmjtNum; vec: PmjtNum); cdecl;
  // Multiply dense or sparse constraint Jacobian transpose by vector.
  Tmj_mulJacTVec = procedure(m: PmjModel; d: PmjData; res: PmjtNum; vec: PmjtNum); cdecl;
  // Compute 3/6-by-nv end-effector Jacobian of global point attached to given body.
  Tmj_jac = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; point: PmjtNum; body: Int32); cdecl;
  // Compute body frame end-effector Jacobian.
  Tmj_jacBody = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; body: Int32); cdecl;
  // Compute body center-of-mass end-effector Jacobian.
  Tmj_jacBodyCom = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; body: Int32); cdecl;
  // Compute subtree center-of-mass end-effector Jacobian.
  Tmj_jacSubtreeCom = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; body: Int32); cdecl;
  // Compute geom end-effector Jacobian.
  Tmj_jacGeom = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; geom: Int32); cdecl;
  // Compute site end-effector Jacobian.
  Tmj_jacSite = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; site: Int32); cdecl;
  // Compute translation end-effector Jacobian of point, and rotation Jacobian of axis.
  Tmj_jacPointAxis = procedure(m: PmjModel; d: PmjData; jacPoint: PmjtNum; jacAxis: PmjtNum; point: PmjtNum; axis: PmjtNum; body: Int32); cdecl;
  // Compute 3/6-by-nv Jacobian time derivative of global point attached to given body.
  Tmj_jacDot = procedure(m: PmjModel; d: PmjData; jacp: PmjtNum; jacr: PmjtNum; point: PmjtNum; body: Int32); cdecl;
  // Compute subtree angular momentum matrix.
  Tmj_angmomMat = procedure(m: PmjModel; d: PmjData; mat: PmjtNum; body: Int32); cdecl;
  // Get id of object with the specified mjtObj type and name; return -1 if id not found.
  Tmj_name2id = function(m: PmjModel; &type: Int32; name: PAnsiChar): Int32; cdecl;
  // Get name of object with the specified mjtObj type and id; return NULL if name not found.
  Tmj_id2name = function(m: PmjModel; &type: Int32; id: Int32): PAnsiChar; cdecl;
  // Get name of actuator input, determined by the actuator type and input signature; return NULL if the actuator type defines no input names.
  Tmj_actuatorInputName = function(m: PmjModel; id: Int32; input: Int32): PAnsiChar; cdecl;
  // Convert sparse inertia matrix into full (i.e. dense) matrix.
  Tmj_fullM = procedure(m: PmjModel; d: PmjData; dst: PmjtNum); cdecl;
  // Multiply vector by inertia matrix.
  Tmj_mulM = procedure(m: PmjModel; d: PmjData; res: PmjtNum; vec: PmjtNum); cdecl;
  // Multiply vector by (inertia matrix)^(1/2).
  Tmj_mulM2 = procedure(m: PmjModel; d: PmjData; res: PmjtNum; vec: PmjtNum); cdecl;
  // Add inertia matrix to destination matrix (lower triangle only). Destination can be sparse or dense when all int* are NULL.
  Tmj_addM = procedure(m: PmjModel; d: PmjData; dst: PmjtNum; rownnz: PmjInt32; rowadr: PmjInt32; colind: PmjInt32); cdecl;
  // Apply Cartesian force and torque (outside xfrc_applied mechanism).
  Tmj_applyFT = procedure(m: PmjModel; d: PmjData; force: PmjtNum; torque: PmjtNum; point: PmjtNum; body: Int32; qfrc_target: PmjtNum); cdecl;
  // Compute object 6D velocity (rot:lin) in object-centered frame, world/local orientation.
  Tmj_objectVelocity = procedure(m: PmjModel; d: PmjData; objtype: Int32; objid: Int32; res: PmjtNum; flg_local: Int32); cdecl;
  // Compute object 6D acceleration (rot:lin) in object-centered frame, world/local orientation.
  Tmj_objectAcceleration = procedure(m: PmjModel; d: PmjData; objtype: Int32; objid: Int32; res: PmjtNum; flg_local: Int32); cdecl;
  // Return smallest signed distance between two geoms and optionally segment from geom1 to geom2.
  Tmj_geomDistance = function(m: PmjModel; d: PmjData; geom1: Int32; geom2: Int32; distmax: mjtNum; fromto: PmjtNum): mjtNum; cdecl;
  // Return 1 if point is inside a site (convex hull for meshes), 0 otherwise.
  Tmj_insideSite = function(m: PmjModel; d: PmjData; siteid: Int32; point: PmjtNum): Int32; cdecl;
  // Extract 6D force:torque given contact id, in the contact frame.
  Tmj_contactForce = procedure(m: PmjModel; d: PmjData; id: Int32; result: PmjtNum); cdecl;
  // Compute velocity by finite-differencing two positions.
  Tmj_differentiatePos = procedure(m: PmjModel; qvel: PmjtNum; dt: mjtNum; qpos1: PmjtNum; qpos2: PmjtNum); cdecl;
  // Integrate position with given velocity.
  Tmj_integratePos = procedure(m: PmjModel; qpos: PmjtNum; qvel: PmjtNum; dt: mjtNum); cdecl;
  // Normalize all quaternions in qpos-type vector.
  Tmj_normalizeQuat = procedure(m: PmjModel; qpos: PmjtNum); cdecl;
  // Map from body local to global Cartesian coordinates, sameframe takes values from mjtSameFrame.
  Tmj_local2Global = procedure(d: PmjData; xpos: PmjtNum; xmat: PmjtNum; pos: PmjtNum; quat: PmjtNum; body: Int32; sameframe: mjtByte); cdecl;
  // Sum all body masses.
  Tmj_getTotalmass = function(m: PmjModel): mjtNum; cdecl;
  // Scale body masses and inertias to achieve specified total mass.
  Tmj_setTotalmass = procedure(m: PmjModel; newmass: mjtNum); cdecl;
  // Return a config attribute value of a plugin instance; NULL: invalid plugin instance ID or attribute name
  Tmj_getPluginConfig = function(m: PmjModel; plugin_id: Int32; attrib: PAnsiChar): PAnsiChar; cdecl;
  // Load a dynamic library. The dynamic library is assumed to register one or more plugins.
  Tmj_loadPluginLibrary = procedure(path: PAnsiChar); cdecl;
  // Scan a directory and load all dynamic libraries. Dynamic libraries in the specified directory are assumed to register one or more plugins. Optionally, if a callback is specified, it is called for each dynamic library encountered that registers plugins.
  Tmj_loadAllPluginLibraries = procedure(directory: PAnsiChar; callback: mjfPluginLibraryLoadCallback); cdecl;
  // Return version number: 1.0.2 is encoded as 102.
  Tmj_version = function: Int32; cdecl;
  // Return the current version of MuJoCo as a null-terminated string.
  Tmj_versionString = function: PAnsiChar; cdecl;
  // Intersect ray (pnt+x*vec, x>=0) with visible geoms, except geoms in bodyexclude. Return distance (x) to nearest surface, or -1 if no intersection. geomgroup, flg_static are as in mjvOption; geomgroup==NULL skips group exclusion.
  Tmj_ray = function(m: PmjModel; d: PmjData; pnt: PmjtNum; vec: PmjtNum; geomgroup: PmjtByte; flg_static: mjtBool; bodyexclude: Int32; geomid: PmjInt32; normal: PmjtNum): mjtNum; cdecl;
  // Intersect multiple rays emanating from a single point, compute normals if given. Similar semantics to mj_ray, but vec, normal and dist are arrays. Geoms further than cutoff are ignored.
  Tmj_multiRay = procedure(m: PmjModel; d: PmjData; pnt: PmjtNum; vec: PmjtNum; geomgroup: PmjtByte; flg_static: mjtBool; bodyexclude: Int32; geomid: PmjInt32; dist: PmjtNum; normal: PmjtNum; nray: Int32; cutoff: mjtNum); cdecl;
  // Intersect ray with hfield; return nearest distance or -1 if no intersection.
  Tmj_rayHfield = function(m: PmjModel; d: PmjData; geomid: Int32; pnt: PmjtNum; vec: PmjtNum; normal: PmjtNum): mjtNum; cdecl;
  // Intersect ray with mesh; return nearest distance or -1 if no intersection.
  Tmj_rayMesh = function(m: PmjModel; d: PmjData; geomid: Int32; pnt: PmjtNum; vec: PmjtNum; normal: PmjtNum): mjtNum; cdecl;
  // Intersect ray with pure geom; return nearest distance or -1 if no intersection.
  Tmju_rayGeom = function(pos: PmjtNum; mat: PmjtNum; size: PmjtNum; pnt: PmjtNum; vec: PmjtNum; geomtype: Int32; normal: PmjtNum): mjtNum; cdecl;
  // Intersect ray with flex; return nearest distance or -1 if no intersection, and also output nearest vertex id and surface normal.
  Tmj_rayFlex = function(m: PmjModel; d: PmjData; flex_layer: Int32; flg_vert: mjtBool; flg_edge: mjtBool; flg_face: mjtBool; flg_skin: mjtBool; flexid: Int32; pnt: PmjtNum; vec: PmjtNum; vertid: PmjInt32; normal: PmjtNum): mjtNum; cdecl;
  // Intersect ray with skin; return nearest distance or -1 if no intersection, and also output nearest vertex id.
  Tmju_raySkin = function(nface: Int32; nvert: Int32; face: PmjInt32; vert: PmjSingle; pnt: PmjtNum; vec: PmjtNum; vertid: PmjInt32): mjtNum; cdecl;
  // Set default camera.
  Tmjv_defaultCamera = procedure(cam: PmjvCamera); cdecl;
  // Set default free camera.
  Tmjv_defaultFreeCamera = procedure(m: PmjModel; cam: PmjvCamera); cdecl;
  // Set default perturbation.
  Tmjv_defaultPerturb = procedure(pert: PmjvPerturb); cdecl;
  // Transform pose from room to model space.
  Tmjv_room2model = procedure(modelpos: PmjtNum; modelquat: PmjtNum; roompos: PmjtNum; roomquat: PmjtNum; scn: PmjvScene); cdecl;
  // Transform pose from model to room space.
  Tmjv_model2room = procedure(roompos: PmjtNum; roomquat: PmjtNum; modelpos: PmjtNum; modelquat: PmjtNum; scn: PmjvScene); cdecl;
  // Get camera info in model space; average left and right OpenGL cameras.
  Tmjv_cameraInModel = procedure(headpos: PmjtNum; forward: PmjtNum; up: PmjtNum; scn: PmjvScene); cdecl;
  // Get camera info in room space; average left and right OpenGL cameras.
  Tmjv_cameraInRoom = procedure(headpos: PmjtNum; forward: PmjtNum; up: PmjtNum; scn: PmjvScene); cdecl;
  // Get frustum height at unit distance from camera; average left and right OpenGL cameras.
  Tmjv_frustumHeight = function(scn: PmjvScene): mjtNum; cdecl;
  // Rotate 3D vec in horizontal plane by angle between (0,1) and (forward_x,forward_y).
  Tmjv_alignToCamera = procedure(res: PmjtNum; vec: PmjtNum; forward: PmjtNum); cdecl;
  // Move camera with mouse; action is mjtMouse.
  Tmjv_moveCamera = procedure(m: PmjModel; action: Int32; reldx: mjtNum; reldy: mjtNum; cam: PmjvCamera); cdecl;
  // Move perturb object with mouse; action is mjtMouse.
  Tmjv_movePerturb = procedure(m: PmjModel; d: PmjData; action: Int32; reldx: mjtNum; reldy: mjtNum; scn: PmjvScene; pert: PmjvPerturb); cdecl;
  // Move model with mouse; action is mjtMouse.
  Tmjv_moveModel = procedure(m: PmjModel; action: Int32; reldx: mjtNum; reldy: mjtNum; roomup: PmjtNum; scn: PmjvScene); cdecl;
  // Copy perturb pos,quat from selected body; set scale for perturbation.
  Tmjv_initPerturb = procedure(m: PmjModel; d: PmjData; scn: PmjvScene; pert: PmjvPerturb); cdecl;
  // Set perturb pos,quat in d->mocap when selected body is mocap, and in d->qpos otherwise. Write d->qpos only if flg_paused and subtree root for selected body has free joint.
  Tmjv_applyPerturbPose = procedure(m: PmjModel; d: PmjData; pert: PmjvPerturb; flg_paused: Int32); cdecl;
  // Set perturb force,torque in d->xfrc_applied, if selected body is dynamic.
  Tmjv_applyPerturbForce = procedure(m: PmjModel; d: PmjData; pert: PmjvPerturb); cdecl;
  // Return the average of two OpenGL cameras.
  Tmjv_averageCamera = function(cam1: PmjvGLCamera; cam2: PmjvGLCamera): mjvGLCamera; cdecl;
  // Converts a mjvCamera to a mjvGLCamera.
  Tmjv_camera2GLCamera = function(model: PmjModel; data: PmjData; mjv_camera: PmjvCamera): mjvGLCamera; cdecl;
  // Select geom, flex or skin with mouse; return bodyid; -1: none selected.
  Tmjv_select = function(m: PmjModel; d: PmjData; vopt: PmjvOption; aspectratio: mjtNum; relx: mjtNum; rely: mjtNum; scn: PmjvScene; selpnt: PmjtNum; geomid: PmjInt32; flexid: PmjInt32; skinid: PmjInt32): Int32; cdecl;
  // Set default visualization options.
  Tmjv_defaultOption = procedure(opt: PmjvOption); cdecl;
  // Set default figure.
  Tmjv_defaultFigure = procedure(fig: PmjvFigure); cdecl;
  // Initialize given geom fields when not NULL, set the rest to their default values.
  Tmjv_initGeom = procedure(geom: PmjvGeom; &type: Int32; size: PmjtNum; pos: PmjtNum; mat: PmjtNum; rgba: PmjSingle); cdecl;
  // Set (type, size, pos, mat) for connector-type geom between given points. Assume that mjv_initGeom was already called to set all other properties. Width of mjGEOM_LINE is denominated in pixels.
  Tmjv_connector = procedure(geom: PmjvGeom; &type: Int32; width: mjtNum; from: PmjtNum; &to: PmjtNum); cdecl;
  // Set default abstract scene.
  Tmjv_defaultScene = procedure(scn: PmjvScene); cdecl;
  // Allocate resources in abstract scene.
  Tmjv_makeScene = procedure(m: PmjModel; scn: PmjvScene; maxgeom: Int32); cdecl;
  // Free abstract scene.
  Tmjv_freeScene = procedure(scn: PmjvScene); cdecl;
  // Update entire scene given model state.
  Tmjv_updateScene = procedure(m: PmjModel; d: PmjData; opt: PmjvOption; pert: PmjvPerturb; cam: PmjvCamera; catmask: Int32; scn: PmjvScene); cdecl;
  // Copy mjModel, skip large arrays not required for abstract visualization.
  Tmjv_copyModel = procedure(dest: PmjModel; src: PmjModel); cdecl;
  // Add geoms from selected categories.
  Tmjv_addGeoms = procedure(m: PmjModel; d: PmjData; opt: PmjvOption; pert: PmjvPerturb; catmask: Int32; scn: PmjvScene); cdecl;
  // Make list of lights.
  Tmjv_makeLights = procedure(m: PmjModel; d: PmjData; scn: PmjvScene); cdecl;
  // Update camera.
  Tmjv_updateCamera = procedure(m: PmjModel; d: PmjData; cam: PmjvCamera; scn: PmjvScene); cdecl;
  // Update skins.
  Tmjv_updateSkin = procedure(m: PmjModel; d: PmjData; scn: PmjvScene); cdecl;
  // Compute camera position and forward, up, and right vectors.
  Tmjv_cameraFrame = procedure(headpos: PmjtNum; forward: PmjtNum; up: PmjtNum; right: PmjtNum; d: PmjData; cam: PmjvCamera); cdecl;
  // Compute camera frustum: vertical, horizontal, and clip planes.
  Tmjv_cameraFrustum = procedure(zver: PmjSingle; zhor: PmjSingle; zclip: PmjSingle; m: PmjModel; cam: PmjvCamera); cdecl;
  // Set default mjrContext.
  Tmjr_defaultContext = procedure(con: PmjrContext); cdecl;
  // Set default mjrRendererInfo.
  Tmjr_defaultRendererInfo = procedure(info: PmjrRendererInfo); cdecl;
  // Get active renderer information.
  Tmjr_getRendererInfo = procedure(info: PmjrRendererInfo); cdecl;
  // Allocate resources in custom OpenGL context; fontscale is mjtFontScale.
  Tmjr_makeContext = procedure(m: PmjModel; con: PmjrContext; fontscale: Int32); cdecl;
  // Change font of existing context.
  Tmjr_changeFont = procedure(fontscale: Int32; con: PmjrContext); cdecl;
  // Add Aux buffer with given index to context; free previous Aux buffer.
  Tmjr_addAux = procedure(index: Int32; width: Int32; height: Int32; samples: Int32; con: PmjrContext); cdecl;
  // Free resources in custom OpenGL context, set to default.
  Tmjr_freeContext = procedure(con: PmjrContext); cdecl;
  // Resize offscreen buffers.
  Tmjr_resizeOffscreen = procedure(width: Int32; height: Int32; con: PmjrContext); cdecl;
  // Upload texture to GPU, overwriting previous upload if any. A by-reference texture (tex_adr == -1) is decoded with mj_loadTexture.
  Tmjr_uploadTexture = procedure(m: PmjModel; con: PmjrContext; texid: Int32); cdecl;
  // Upload mesh to GPU, overwriting previous upload if any.
  Tmjr_uploadMesh = procedure(m: PmjModel; con: PmjrContext; meshid: Int32); cdecl;
  // Upload height field to GPU, overwriting previous upload if any.
  Tmjr_uploadHField = procedure(m: PmjModel; con: PmjrContext; hfieldid: Int32); cdecl;
  // Make con->currentBuffer current again.
  Tmjr_restoreBuffer = procedure(con: PmjrContext); cdecl;
  // Set OpenGL framebuffer for rendering: mjFB_WINDOW or mjFB_OFFSCREEN. If only one buffer is available, set that buffer and ignore framebuffer argument.
  Tmjr_setBuffer = procedure(framebuffer: Int32; con: PmjrContext); cdecl;
  // Read pixels from current OpenGL framebuffer to client buffer. Viewport is in OpenGL framebuffer; client buffer starts at (0,0).
  Tmjr_readPixels = procedure(rgb: PByte; depth: PmjSingle; viewport: mjrRect; con: PmjrContext); cdecl;
  // Draw pixels from client buffer to current OpenGL framebuffer. Viewport is in OpenGL framebuffer; client buffer starts at (0,0).
  Tmjr_drawPixels = procedure(rgb: PByte; depth: PmjSingle; viewport: mjrRect; con: PmjrContext); cdecl;
  // Blit from src viewpoint in current framebuffer to dst viewport in other framebuffer. If src, dst have different size and flg_depth==0, color is interpolated with GL_LINEAR.
  Tmjr_blitBuffer = procedure(src: mjrRect; dst: mjrRect; flg_color: Int32; flg_depth: Int32; con: PmjrContext); cdecl;
  // Set Aux buffer for custom OpenGL rendering (call restoreBuffer when done).
  Tmjr_setAux = procedure(index: Int32; con: PmjrContext); cdecl;
  // Blit from Aux buffer to con->currentBuffer.
  Tmjr_blitAux = procedure(index: Int32; src: mjrRect; left: Int32; bottom: Int32; con: PmjrContext); cdecl;
  // Draw text at (x,y) in relative coordinates; font is mjtFont.
  Tmjr_text = procedure(font: Int32; txt: PAnsiChar; con: PmjrContext; x: Single; y: Single; r: Single; g: Single; b: Single); cdecl;
  // Draw text overlay; font is mjtFont; gridpos is mjtGridPos.
  Tmjr_overlay = procedure(font: Int32; gridpos: Int32; viewport: mjrRect; overlay: PAnsiChar; overlay2: PAnsiChar; con: PmjrContext); cdecl;
  // Get maximum viewport for active buffer.
  Tmjr_maxViewport = function(con: PmjrContext): mjrRect; cdecl;
  // Draw rectangle.
  Tmjr_rectangle = procedure(viewport: mjrRect; r: Single; g: Single; b: Single; a: Single); cdecl;
  // Draw rectangle with centered text.
  Tmjr_label = procedure(viewport: mjrRect; font: Int32; txt: PAnsiChar; r: Single; g: Single; b: Single; a: Single; rt: Single; gt: Single; bt: Single; con: PmjrContext); cdecl;
  // Draw 2D figure.
  Tmjr_figure = procedure(viewport: mjrRect; fig: PmjvFigure; con: PmjrContext); cdecl;
  // Render 3D scene.
  Tmjr_render = procedure(viewport: mjrRect; scn: PmjvScene; con: PmjrContext); cdecl;
  // Call glFinish.
  Tmjr_finish = procedure; cdecl;
  // Call glGetError and return result.
  Tmjr_getError = function: Int32; cdecl;
  // Find first rectangle containing mouse, -1: not found.
  Tmjr_findRect = function(x: Int32; y: Int32; nrect: Int32; rect: PmjrRect): Int32; cdecl;
  // Main error function; does not return to caller.
  Tmju_error = procedure(msg: PAnsiChar); cdecl;
  // Main warning function; returns to caller.
  Tmju_warning = procedure(msg: PAnsiChar); cdecl;
  // Clear user error and memory handlers.
  Tmju_clearHandlers = procedure; cdecl;
  // Set the active log handler; return the previous handler. If handler is NULL, restore the default handler.
  Tmju_setLogHandler = function(handler: mjfLogHandler): mjfLogHandler; cdecl;
  // Get default handler configuration.
  Tmju_getLogConfig = function: mjLogConfig; cdecl;
  // Set default handler configuration.
  Tmju_setLogConfig = procedure(config: mjLogConfig); cdecl;
  // Log an info message with optional topic filtering.
  Tmju_info = procedure(topic: Int32; msg: PAnsiChar); cdecl;
  // Dispatch a structured log message to the active handler.
  Tmju_message = procedure(msg: PmjLogMessage); cdecl;
  // Allocate memory; byte-align on 64; pad size to multiple of 64.
  Tmju_malloc = function(size: NativeUInt): Pointer; cdecl;
  // Free memory, using free() by default.
  Tmju_free = procedure(ptr: Pointer); cdecl;
  // High-level warning function: count warnings in mjData, print only the first.
  Tmj_warning = procedure(d: PmjData; warning: Int32; info: Int32); cdecl;
  // Write [datetime, type: message] to MUJOCO_LOG.TXT.
  Tmju_writeLog = procedure(&type: PAnsiChar; msg: PAnsiChar); cdecl;
  // Get compiler error message from spec.
  Tmjs_getError = function(s: PmjSpec): PAnsiChar; cdecl;
  // Get compiler timing diagnostics from spec, returns pointer to array of size mjNCTIMER.
  Tmjs_getTimer = function(s: PmjSpec): PmjDouble; cdecl;
  // Return 1 if compiler error is a warning. Deprecated: use mjs_numWarnings(s) > 0.
  Tmjs_isWarning = function(s: PmjSpec): Int32; cdecl;
  // Get number of warnings accumulated in the spec.
  Tmjs_numWarnings = function(spec: PmjSpec): Int32; cdecl;
  // Get the i-th warning message (returns nullptr if index out of bounds).
  Tmjs_getWarning = function(spec: PmjSpec; index: Int32): PAnsiChar; cdecl;
  // Set res = 0.
  Tmju_zero3 = procedure(res: PmjtNum); cdecl;
  // Set res = vec.
  Tmju_copy3 = procedure(res: PmjtNum; data: PmjtNum); cdecl;
  // Set res = vec*scl.
  Tmju_scl3 = procedure(res: PmjtNum; vec: PmjtNum; scl: mjtNum); cdecl;
  // Set res = vec1 + vec2.
  Tmju_add3 = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum); cdecl;
  // Set res = vec1 - vec2.
  Tmju_sub3 = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum); cdecl;
  // Set res = res + vec.
  Tmju_addTo3 = procedure(res: PmjtNum; vec: PmjtNum); cdecl;
  // Set res = res - vec.
  Tmju_subFrom3 = procedure(res: PmjtNum; vec: PmjtNum); cdecl;
  // Set res = res + vec*scl.
  Tmju_addToScl3 = procedure(res: PmjtNum; vec: PmjtNum; scl: mjtNum); cdecl;
  // Set res = vec1 + vec2*scl.
  Tmju_addScl3 = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum; scl: mjtNum); cdecl;
  // Normalize vector; return length before normalization.
  Tmju_normalize3 = function(vec: PmjtNum): mjtNum; cdecl;
  // Return vector length (without normalizing the vector).
  Tmju_norm3 = function(vec: PmjtNum): mjtNum; cdecl;
  // Return dot-product of vec1 and vec2.
  Tmju_dot3 = function(vec1: PmjtNum; vec2: PmjtNum): mjtNum; cdecl;
  // Return Cartesian distance between 3D vectors pos1 and pos2.
  Tmju_dist3 = function(pos1: PmjtNum; pos2: PmjtNum): mjtNum; cdecl;
  // Multiply 3-by-3 matrix by vector: res = mat * vec.
  Tmju_mulMatVec3 = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum); cdecl;
  // Multiply transposed 3-by-3 matrix by vector: res = mat' * vec.
  Tmju_mulMatTVec3 = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum); cdecl;
  // Compute cross-product: res = cross(a, b).
  Tmju_cross = procedure(res: PmjtNum; a: PmjtNum; b: PmjtNum); cdecl;
  // Set res = 0.
  Tmju_zero4 = procedure(res: PmjtNum); cdecl;
  // Set res = (1,0,0,0).
  Tmju_unit4 = procedure(res: PmjtNum); cdecl;
  // Set res = vec.
  Tmju_copy4 = procedure(res: PmjtNum; data: PmjtNum); cdecl;
  // Normalize vector; return length before normalization.
  Tmju_normalize4 = function(vec: PmjtNum): mjtNum; cdecl;
  // Set res = 0.
  Tmju_zero = procedure(res: PmjtNum; n: Int32); cdecl;
  // Set res = val.
  Tmju_fill = procedure(res: PmjtNum; val: mjtNum; n: Int32); cdecl;
  // Set res = vec.
  Tmju_copy = procedure(res: PmjtNum; vec: PmjtNum; n: Int32); cdecl;
  // Return sum(vec).
  Tmju_sum = function(vec: PmjtNum; n: Int32): mjtNum; cdecl;
  // Return L1 norm: sum(abs(vec)).
  Tmju_L1 = function(vec: PmjtNum; n: Int32): mjtNum; cdecl;
  // Set res = vec*scl.
  Tmju_scl = procedure(res: PmjtNum; vec: PmjtNum; scl: mjtNum; n: Int32); cdecl;
  // Set res = vec1 + vec2.
  Tmju_add = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum; n: Int32); cdecl;
  // Set res = vec1 - vec2.
  Tmju_sub = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum; n: Int32); cdecl;
  // Set res = res + vec.
  Tmju_addTo = procedure(res: PmjtNum; vec: PmjtNum; n: Int32); cdecl;
  // Set res = res - vec.
  Tmju_subFrom = procedure(res: PmjtNum; vec: PmjtNum; n: Int32); cdecl;
  // Set res = res + vec*scl.
  Tmju_addToScl = procedure(res: PmjtNum; vec: PmjtNum; scl: mjtNum; n: Int32); cdecl;
  // Set res = vec1 + vec2*scl.
  Tmju_addScl = procedure(res: PmjtNum; vec1: PmjtNum; vec2: PmjtNum; scl: mjtNum; n: Int32); cdecl;
  // Normalize vector; return length before normalization.
  Tmju_normalize = function(res: PmjtNum; n: Int32): mjtNum; cdecl;
  // Return vector length (without normalizing vector).
  Tmju_norm = function(res: PmjtNum; n: Int32): mjtNum; cdecl;
  // Return dot-product of vec1 and vec2.
  Tmju_dot = function(vec1: PmjtNum; vec2: PmjtNum; n: Int32): mjtNum; cdecl;
  // Multiply matrix and vector: res = mat * vec.
  Tmju_mulMatVec = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum; nr: Int32; nc: Int32); cdecl;
  // Multiply transposed matrix and vector: res = mat' * vec.
  Tmju_mulMatTVec = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum; nr: Int32; nc: Int32); cdecl;
  // Multiply square matrix with vectors on both sides: return vec1' * mat * vec2.
  Tmju_mulVecMatVec = function(vec1: PmjtNum; mat: PmjtNum; vec2: PmjtNum; n: Int32): mjtNum; cdecl;
  // Transpose matrix: res = mat'.
  Tmju_transpose = procedure(res: PmjtNum; mat: PmjtNum; nr: Int32; nc: Int32); cdecl;
  // Symmetrize square matrix res = (mat + mat')/2.
  Tmju_symmetrize = procedure(res: PmjtNum; mat: PmjtNum; n: Int32); cdecl;
  // Set mat to the identity matrix.
  Tmju_eye = procedure(mat: PmjtNum; n: Int32); cdecl;
  // Multiply matrices: res = mat1 * mat2.
  Tmju_mulMatMat = procedure(res: PmjtNum; mat1: PmjtNum; mat2: PmjtNum; r1: Int32; c1: Int32; c2: Int32); cdecl;
  // Multiply matrices, second argument transposed: res = mat1 * mat2'.
  Tmju_mulMatMatT = procedure(res: PmjtNum; mat1: PmjtNum; mat2: PmjtNum; r1: Int32; c1: Int32; r2: Int32); cdecl;
  // Multiply matrices, first argument transposed: res = mat1' * mat2.
  Tmju_mulMatTMat = procedure(res: PmjtNum; mat1: PmjtNum; mat2: PmjtNum; r1: Int32; c1: Int32; c2: Int32); cdecl;
  // Set res = mat' * diag * mat if diag is not NULL, and res = mat' * mat otherwise.
  Tmju_sqrMatTD = procedure(res: PmjtNum; mat: PmjtNum; diag: PmjtNum; nr: Int32; nc: Int32); cdecl;
  // Coordinate transform of 6D motion or force vector in rotation:translation format. rotnew2old is 3-by-3, NULL means no rotation; flg_force specifies force or motion type.
  Tmju_transformSpatial = procedure(res: PmjtNum; vec: PmjtNum; flg_force: Int32; newpos: PmjtNum; oldpos: PmjtNum; rotnew2old: PmjtNum); cdecl;
  // Convert matrix from dense to sparse.  nnz is size of res and colind; return 1 if too small, 0 otherwise.
  Tmju_dense2sparse = function(res: PmjtNum; mat: PmjtNum; nr: Int32; nc: Int32; rownnz: PmjInt32; rowadr: PmjInt32; colind: PmjInt32; nnz: Int32): Int32; cdecl;
  // Convert matrix from sparse to dense.
  Tmju_sparse2dense = procedure(res: PmjtNum; mat: PmjtNum; nr: Int32; nc: Int32; rownnz: PmjInt32; rowadr: PmjInt32; colind: PmjInt32); cdecl;
  // Convert lower-triangular symmetric CSR matrix to full dense matrix.
  Tmju_sym2dense = procedure(res: PmjtNum; mat: PmjtNum; n: Int32; rownnz: PmjInt32; rowadr: PmjInt32; colind: PmjInt32); cdecl;
  // Rotate vector by quaternion.
  Tmju_rotVecQuat = procedure(res: PmjtNum; vec: PmjtNum; quat: PmjtNum); cdecl;
  // Conjugate quaternion, corresponding to opposite rotation.
  Tmju_negQuat = procedure(res: PmjtNum; quat: PmjtNum); cdecl;
  // Multiply quaternions.
  Tmju_mulQuat = procedure(res: PmjtNum; quat1: PmjtNum; quat2: PmjtNum); cdecl;
  // Multiply quaternion and axis.
  Tmju_mulQuatAxis = procedure(res: PmjtNum; quat: PmjtNum; axis: PmjtNum); cdecl;
  // Convert axisAngle to quaternion.
  Tmju_axisAngle2Quat = procedure(res: PmjtNum; axis: PmjtNum; angle: mjtNum); cdecl;
  // Convert quaternion (corresponding to orientation difference) to 3D velocity.
  Tmju_quat2Vel = procedure(res: PmjtNum; quat: PmjtNum; dt: mjtNum); cdecl;
  // Subtract quaternions, express as 3D velocity: qb*quat(res) = qa.
  Tmju_subQuat = procedure(res: PmjtNum; qa: PmjtNum; qb: PmjtNum); cdecl;
  // Convert quaternion to 3D rotation matrix.
  Tmju_quat2Mat = procedure(res: PmjtNum; quat: PmjtNum); cdecl;
  // Convert 3D rotation matrix to quaternion.
  Tmju_mat2Quat = procedure(quat: PmjtNum; mat: PmjtNum); cdecl;
  // Compute time-derivative of quaternion, given 3D rotational velocity.
  Tmju_derivQuat = procedure(res: PmjtNum; quat: PmjtNum; vel: PmjtNum); cdecl;
  // Integrate quaternion given 3D angular velocity.
  Tmju_quatIntegrate = procedure(quat: PmjtNum; vel: PmjtNum; scale: mjtNum); cdecl;
  // Construct quaternion performing rotation from z-axis to given vector.
  Tmju_quatZ2Vec = procedure(quat: PmjtNum; vec: PmjtNum); cdecl;
  // Extract 3D rotation from an arbitrary 3x3 matrix by refining the input quaternion. Return the number of iterations required to converge.
  Tmju_mat2Rot = function(quat: PmjtNum; mat: PmjtNum): Int32; cdecl;
  // Convert sequence of Euler angles (radians) to quaternion. seq[0,1,2] must be in 'xyzXYZ', lower/upper-case mean intrinsic/extrinsic rotations.
  Tmju_euler2Quat = procedure(quat: PmjtNum; euler: PmjtNum; seq: PAnsiChar); cdecl;
  // Multiply two poses.
  Tmju_mulPose = procedure(posres: PmjtNum; quatres: PmjtNum; pos1: PmjtNum; quat1: PmjtNum; pos2: PmjtNum; quat2: PmjtNum); cdecl;
  // Conjugate pose, corresponding to the opposite spatial transformation.
  Tmju_negPose = procedure(posres: PmjtNum; quatres: PmjtNum; pos: PmjtNum; quat: PmjtNum); cdecl;
  // Transform vector by pose.
  Tmju_trnVecPose = procedure(res: PmjtNum; pos: PmjtNum; quat: PmjtNum; vec: PmjtNum); cdecl;
  // Cholesky decomposition: mat = L*L'; return rank, decomposition performed in-place into mat.
  Tmju_cholFactor = function(mat: PmjtNum; n: Int32; mindiag: mjtNum): Int32; cdecl;
  // Solve (mat*mat') * res = vec, where mat is a Cholesky factor.
  Tmju_cholSolve = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum; n: Int32); cdecl;
  // Cholesky rank-one update: L*L' +/- x*x'; return rank.
  Tmju_cholUpdate = function(mat: PmjtNum; x: PmjtNum; n: Int32; flg_plus: Int32): Int32; cdecl;
  // Band-dense Cholesky decomposition.  Return minimum value in the factorized diagonal, or 0 if rank-deficient.  mat has (ntotal-ndense) x nband + ndense x ntotal elements.  The first (ntotal-ndense) x nband store the band part, left of diagonal, inclusive.  The second ndense x ntotal store the band part as entire dense rows.  Add diagadd+diagmul*mat_ii to diagonal before factorization.
  Tmju_cholFactorBand = function(mat: PmjtNum; ntotal: Int32; nband: Int32; ndense: Int32; diagadd: mjtNum; diagmul: mjtNum): mjtNum; cdecl;
  // Solve (mat*mat')*res = vec where mat is a band-dense Cholesky factor.
  Tmju_cholSolveBand = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum; ntotal: Int32; nband: Int32; ndense: Int32); cdecl;
  // Convert banded matrix to dense matrix, fill upper triangle if flg_sym>0.
  Tmju_band2Dense = procedure(res: PmjtNum; mat: PmjtNum; ntotal: Int32; nband: Int32; ndense: Int32; flg_sym: mjtBool); cdecl;
  // Convert dense matrix to banded matrix.
  Tmju_dense2Band = procedure(res: PmjtNum; mat: PmjtNum; ntotal: Int32; nband: Int32; ndense: Int32); cdecl;
  // Multiply band-diagonal matrix with nvec vectors, include upper triangle if flg_sym>0.
  Tmju_bandMulMatVec = procedure(res: PmjtNum; mat: PmjtNum; vec: PmjtNum; ntotal: Int32; nband: Int32; ndense: Int32; nvec: Int32; flg_sym: mjtBool); cdecl;
  // Address of diagonal element i in band-dense matrix representation.
  Tmju_bandDiag = function(i: Int32; ntotal: Int32; nband: Int32; ndense: Int32): Int32; cdecl;
  // Eigenvalue decomposition of symmetric 3x3 matrix, mat = eigvec * diag(eigval) * eigvec'.
  Tmju_eig3 = function(eigval: PmjtNum; eigvec: PmjtNum; quat: PmjtNum; mat: PmjtNum): Int32; cdecl;
  // minimize 0.5*x'*H*x + x'*g  s.t. lower <= x <= upper; return rank or -1 if failed   inputs:     n           - problem dimension     H           - SPD matrix                n*n     g           - bias vector               n     lower       - lower bounds              n     upper       - upper bounds              n     res         - solution warmstart        n   return value:     nfree <= n  - rank of unconstrained subspace, -1 if failure   outputs (required):     res         - solution                  n     R           - subspace Cholesky factor  nfree*nfree    allocated: n*(n+7)   outputs (optional):     index       - set of free dimensions    nfree          allocated: n   notes:     the initial value of res is used to warmstart the solver     R must have allocatd size n*(n+7), but only nfree*nfree values are used in output     index (if given) must have allocated size n, but only nfree values are used in output     only the lower triangles of H and R and are read from and written to, respectively     the convenience function mju_boxQPmalloc allocates the required data structures
  Tmju_boxQP = function(res: PmjtNum; R: PmjtNum; index: PmjInt32; H: PmjtNum; g: PmjtNum; n: Int32; lower: PmjtNum; upper: PmjtNum): Int32; cdecl;
  // allocate heap memory for box-constrained Quadratic Program   as in mju_boxQP, index, lower, and upper are optional   free all pointers with mju_free()
  Tmju_boxQPmalloc = procedure(res: PPmjtNum; R: PPmjtNum; index: PPmjInt32; H: PPmjtNum; g: PPmjtNum; n: Int32; lower: PPmjtNum; upper: PPmjtNum); cdecl;
  // Muscle active force, prm = (range[2], force, scale, lmin, lmax, vmax, fpmax, fvmax).
  Tmju_muscleGain = function(len: mjtNum; vel: mjtNum; lengthrange: PmjtNum; acc0: mjtNum; prm: PmjtNum): mjtNum; cdecl;
  // Muscle passive force, prm = (range[2], force, scale, lmin, lmax, vmax, fpmax, fvmax).
  Tmju_muscleBias = function(len: mjtNum; lengthrange: PmjtNum; acc0: mjtNum; prm: PmjtNum): mjtNum; cdecl;
  // Muscle activation dynamics, prm = (tau_act, tau_deact, smoothing_width).
  Tmju_muscleDynamics = function(ctrl: mjtNum; act: mjtNum; prm: PmjtNum): mjtNum; cdecl;
  // Convert contact force to pyramid representation.
  Tmju_encodePyramid = procedure(pyramid: PmjtNum; force: PmjtNum; mu: PmjtNum; dim: Int32); cdecl;
  // Convert pyramid representation to contact force.
  Tmju_decodePyramid = procedure(force: PmjtNum; pyramid: PmjtNum; mu: PmjtNum; dim: Int32); cdecl;
  // Integrate spring-damper analytically; return pos(dt).
  Tmju_springDamper = function(pos0: mjtNum; vel0: mjtNum; Kp: mjtNum; Kv: mjtNum; dt: mjtNum): mjtNum; cdecl;
  // Return min(a,b) with single evaluation of a and b.
  Tmju_min = function(a: mjtNum; b: mjtNum): mjtNum; cdecl;
  // Return max(a,b) with single evaluation of a and b.
  Tmju_max = function(a: mjtNum; b: mjtNum): mjtNum; cdecl;
  // Clip x to the range [min, max].
  Tmju_clip = function(x: mjtNum; min: mjtNum; max: mjtNum): mjtNum; cdecl;
  // Return sign of x: +1, -1 or 0.
  Tmju_sign = function(x: mjtNum): mjtNum; cdecl;
  // Round x to nearest integer.
  Tmju_round = function(x: mjtNum): Int32; cdecl;
  // Convert type id (mjtObj) to type name.
  Tmju_type2Str = function(&type: Int32): PAnsiChar; cdecl;
  // Convert type name to type id (mjtObj).
  Tmju_str2Type = function(str: PAnsiChar): Int32; cdecl;
  // Return human readable number of bytes using standard letter suffix.
  Tmju_writeNumBytes = function(nbytes: NativeUInt): PAnsiChar; cdecl;
  // Construct a warning message given the warning type and info.
  Tmju_warningText = function(warning: Int32; info: NativeUInt): PAnsiChar; cdecl;
  // Return 1 if nan or abs(x)>mjMAXVAL, 0 otherwise. Used by check functions.
  Tmju_isBad = function(x: mjtNum): Int32; cdecl;
  // Return 1 if all elements are 0.
  Tmju_isZero = function(vec: PmjtNum; n: Int32): Int32; cdecl;
  // Standard normal random number generator (optional second number).
  Tmju_standardNormal = function(num2: PmjtNum): mjtNum; cdecl;
  // Convert from float to mjtNum.
  Tmju_f2n = procedure(res: PmjtNum; vec: PmjSingle; n: Int32); cdecl;
  // Convert from mjtNum to float.
  Tmju_n2f = procedure(res: PmjSingle; vec: PmjtNum; n: Int32); cdecl;
  // Convert from double to mjtNum.
  Tmju_d2n = procedure(res: PmjtNum; vec: PmjDouble; n: Int32); cdecl;
  // Convert from mjtNum to double.
  Tmju_n2d = procedure(res: PmjDouble; vec: PmjtNum; n: Int32); cdecl;
  // Insertion sort, resulting list is in increasing order.
  Tmju_insertionSort = procedure(list: PmjtNum; n: Int32); cdecl;
  // Integer insertion sort, resulting list is in increasing order.
  Tmju_insertionSortInt = procedure(list: PmjInt32; n: Int32); cdecl;
  // Generate Halton sequence.
  Tmju_Halton = function(index: Int32; base: Int32): mjtNum; cdecl;
  // Call strncpy, then set dst[n-1] = 0.
  Tmju_strncpy = function(dst: PAnsiChar; src: PAnsiChar; n: Int32): PAnsiChar; cdecl;
  // Sigmoid function over 0<=x<=1 using quintic polynomial.
  Tmju_sigmoid = function(x: mjtNum): mjtNum; cdecl;
  // get sdf from geom id
  Tmjc_getSDF = function(m: PmjModel; id: Int32): PmjpPlugin; cdecl;
  // signed distance function
  Tmjc_distance = function(m: PmjModel; d: PmjData; s: PmjSDF; x: PmjtNum): mjtNum; cdecl;
  // gradient of sdf
  Tmjc_gradient = procedure(m: PmjModel; d: PmjData; s: PmjSDF; gradient: PmjtNum; x: PmjtNum); cdecl;
  // Finite differenced transition matrices (control theory notation)   d(x_next) = A*dx + B*du   d(sensor) = C*dx + D*du   required output matrix dimensions:      A: (2*nv+na x 2*nv+na)      B: (2*nv+na x nu)      D: (nsensordata x 2*nv+na)      C: (nsensordata x nu)
  Tmjd_transitionFD = procedure(m: PmjModel; d: PmjData; eps: mjtNum; flg_centered: mjtBool; A: PmjtNum; B: PmjtNum; C: PmjtNum; aD: PmjtNum); cdecl;
  // Finite differenced Jacobians of (force, sensors) = mj_inverse(state, acceleration)   All outputs are optional. Output dimensions (transposed w.r.t Control Theory convention):     DfDq: (nv x nv)     DfDv: (nv x nv)     DfDa: (nv x nv)     DsDq: (nv x nsensordata)     DsDv: (nv x nsensordata)     DsDa: (nv x nsensordata)     DmDq: (nv x nC)   single-letter shortcuts:     inputs: q=qpos, v=qvel, a=qacc     outputs: f=qfrc_inverse, s=sensordata, m=M   notes:     optionally computes mass matrix Jacobian DmDq     flg_actuation specifies whether to subtract qfrc_actuator from qfrc_inverse
  Tmjd_inverseFD = procedure(m: PmjModel; d: PmjData; eps: mjtNum; flg_actuation: mjtBool; DfDq: PmjtNum; DfDv: PmjtNum; DfDa: PmjtNum; DsDq: PmjtNum; DsDv: PmjtNum; DsDa: PmjtNum; DmDq: PmjtNum); cdecl;
  // Derivatives of mju_subQuat.
  Tmjd_subQuat = procedure(qa: PmjtNum; qb: PmjtNum; Da: PmjtNum; Db: PmjtNum); cdecl;
  // Derivatives of mju_quatIntegrate.
  Tmjd_quatIntegrate = procedure(vel: PmjtNum; scale: mjtNum; Dquat: PmjtNum; Dvel: PmjtNum; Dscale: PmjtNum); cdecl;
  // Set default plugin definition.
  Tmjp_defaultPlugin = procedure(plugin: PmjpPlugin); cdecl;
  // Globally register a plugin. This function is thread-safe. If an identical mjpPlugin is already registered, this function does nothing. If a non-identical mjpPlugin with the same name is already registered, an mju_error is raised. Two mjpPlugins are considered identical if all member function pointers and numbers are equal, and the name and attribute strings are all identical, however the char pointers to the strings need not be the same.
  Tmjp_registerPlugin = function(plugin: PmjpPlugin): Int32; cdecl;
  // Return the number of globally registered plugins.
  Tmjp_pluginCount = function: Int32; cdecl;
  // Look up a plugin by name. If slot is not NULL, also write its registered slot number into it.
  Tmjp_getPlugin = function(name: PAnsiChar; slot: PmjInt32): PmjpPlugin; cdecl;
  // Look up a plugin by the registered slot number that was returned by mjp_registerPlugin.
  Tmjp_getPluginAtSlot = function(slot: Int32): PmjpPlugin; cdecl;
  // Set default provider definition.
  Tmjp_defaultProvider = procedure(provider: PmjpResourceProvider); cdecl;
  // Globally register a provider in a thread-safe manner. The provider must have a prefix that is not a sub-prefix or super-prefix of any current registered providers. Return a slot number >= 0 on success, -1 on failure.
  Tmjp_registerProvider = function(provider: PmjpResourceProvider): Int32; cdecl;
  // Return the number of globally registered providers.
  Tmjp_providerCount = function: Int32; cdecl;
  // Return the provider with the prefix that matches against the resource name. If no match, return NULL.
  Tmjp_findProvider = function(resource_name: PAnsiChar): PmjpResourceProvider; cdecl;
  // Look up a provider by slot number returned by mjp_registerProvider. If invalid slot number, return NULL.
  Tmjp_getProviderAtSlot = function(slot: Int32): PmjpResourceProvider; cdecl;
  // Globally register a decoder. This function is thread-safe. If an identical mjpDecoder is already registered, this function does nothing. If a non-identical mjpDecoder with the same name is already registered, an mju_error is raised.
  Tmjp_registerDecoder = procedure(decoder: PmjpDecoder); cdecl;
  // Set default resource decoder definition.
  Tmjp_defaultDecoder = procedure(decoder: PmjpDecoder); cdecl;
  // Return the decoder that matches against the resource or content type. If no match, return NULL.
  Tmjp_findDecoder = function(resource: PmjResource; content_type: PAnsiChar): PmjpDecoder; cdecl;
  // Globally register an encoder. This function is thread-safe. If an identical mjpEncoder is already registered, this function does nothing. If a non-identical mjpEncoder with the same name is already registered, an mju_error is raised.
  Tmjp_registerEncoder = procedure(encoder: PmjpEncoder); cdecl;
  // Set default resource encoder definition.
  Tmjp_defaultEncoder = procedure(encoder: PmjpEncoder); cdecl;
  // Return the encoder that matches against the content type or filename extension. If no match, return NULL.
  Tmjp_findEncoder = function(filename: PAnsiChar; content_type: PAnsiChar): PmjpEncoder; cdecl;
  // Globally register an archive provider. This function is thread-safe. provider->prefix specifies the filename extension(s) (e.g. .mjz|.zip).
  Tmjp_registerArchiveProvider = procedure(provider: PmjpResourceProvider); cdecl;
  // Return the archive provider that matches against the resource name. If no match, return NULL.
  Tmjp_findArchiveProvider = function(resource_name: PAnsiChar): PmjpResourceProvider; cdecl;
  // Return the number of globally registered archive providers.
  Tmjp_archiveProviderCount = function: Int32; cdecl;
  // Open a resource; if the name doesn't have a prefix matching a registered provider, then the OS filesystem is used.
  Tmju_openResource = function(dir: PAnsiChar; name: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; nerror: NativeUInt): PmjResource; cdecl;
  // Close a resource; no-op if resource is NULL.
  Tmju_closeResource = procedure(resource: PmjResource); cdecl;
  // Set buffer to bytes read from the resource and return number of bytes in buffer; return negative value if error.
  Tmju_readResource = function(resource: PmjResource; buffer: PPointer): Int32; cdecl;
  // Write resource data via its provider, return bytes written or -1 on error.
  Tmju_writeResource = function(name: PAnsiChar; buffer: Pointer; nbytes: mjtSize; vfs: PmjVFS; error: PAnsiChar; nerror: NativeUInt): mjtSize; cdecl;
  // For a resource with a name partitioned as {dir}{filename}, get the dir and ndir pointers.
  Tmju_getResourceDir = procedure(resource: PmjResource; dir: PPAnsiChar; ndir: PmjInt32); cdecl;
  // Compare resource timestamp to provided timestamp. Return 0 if timestamps match, >0 if resource is newer, <0 if resource is older.
  Tmju_isModifiedResource = function(resource: PmjResource; timestamp: PAnsiChar): Int32; cdecl;
  // Find the decoder for a resource and return the decoded spec. The caller takes ownership of the spec and is responsible for cleaning it up. On failure, return NULL and write the reason to error.
  Tmju_decodeResource = function(resource: PmjResource; content_type: PAnsiChar; vfs: PmjVFS; error: PAnsiChar; error_sz: Int32): PmjSpec; cdecl;
  // Create a thread pool with nthread worker threads.
  Tmju_threadpool = procedure(d: PmjData; nthread: Int32); cdecl;
  // Attach child to a parent; return the attached element if success or NULL otherwise.
  Tmjs_attach = function(parent: PmjsElement; child: PmjsElement; prefix: PAnsiChar; suffix: PAnsiChar): PmjsElement; cdecl;
  // Add child body to body; return child.
  Tmjs_addBody = function(body: PmjsBody; def: PmjsDefault): PmjsBody; cdecl;
  // Add site to body; return site spec.
  Tmjs_addSite = function(body: PmjsBody; def: PmjsDefault): PmjsSite; cdecl;
  // Add joint to body.
  Tmjs_addJoint = function(body: PmjsBody; def: PmjsDefault): PmjsJoint; cdecl;
  // Add freejoint to body.
  Tmjs_addFreeJoint = function(body: PmjsBody): PmjsJoint; cdecl;
  // Add geom to body.
  Tmjs_addGeom = function(body: PmjsBody; def: PmjsDefault): PmjsGeom; cdecl;
  // Add camera to body.
  Tmjs_addCamera = function(body: PmjsBody; def: PmjsDefault): PmjsCamera; cdecl;
  // Add light to body.
  Tmjs_addLight = function(body: PmjsBody; def: PmjsDefault): PmjsLight; cdecl;
  // Add frame to body.
  Tmjs_addFrame = function(body: PmjsBody; parentframe: PmjsFrame): PmjsFrame; cdecl;
  // Remove object corresponding to the given element; return 0 on success.
  Tmjs_delete = function(spec: PmjSpec; element: PmjsElement): Int32; cdecl;
  // Add actuator.
  Tmjs_addActuator = function(s: PmjSpec; def: PmjsDefault): PmjsActuator; cdecl;
  // Add sensor.
  Tmjs_addSensor = function(s: PmjSpec): PmjsSensor; cdecl;
  // Add flex.
  Tmjs_addFlex = function(s: PmjSpec): PmjsFlex; cdecl;
  // Add flexcomp: create flex with auto-generated bodies/joints, return flex spec.
  Tmjs_makeFlex = function(body: PmjsBody; name: PAnsiChar; &type: PAnsiChar; dim: Int32; dof: PAnsiChar; count: PmjInt32; cellcount: PmjInt32; spacing: PmjDouble; scale: PmjDouble; radius: Double; mass: Double; inertiabox: Double; equality: Int32; rigid: Int32; flatskin: Int32; elastic2d: Int32; pos: PmjDouble; quat: PmjDouble; origin: PmjDouble; &file: PAnsiChar; vfs: PmjVFS): PmjsFlex; cdecl;
  // Add contact pair.
  Tmjs_addPair = function(s: PmjSpec; def: PmjsDefault): PmjsPair; cdecl;
  // Add excluded body pair.
  Tmjs_addExclude = function(s: PmjSpec): PmjsExclude; cdecl;
  // Add equality.
  Tmjs_addEquality = function(s: PmjSpec; def: PmjsDefault): PmjsEquality; cdecl;
  // Add tendon.
  Tmjs_addTendon = function(s: PmjSpec; def: PmjsDefault): PmjsTendon; cdecl;
  // Wrap site using tendon.
  Tmjs_wrapSite = function(tendon: PmjsTendon; name: PAnsiChar): PmjsWrap; cdecl;
  // Wrap geom using tendon.
  Tmjs_wrapGeom = function(tendon: PmjsTendon; name: PAnsiChar; sidesite: PAnsiChar): PmjsWrap; cdecl;
  // Wrap joint using tendon.
  Tmjs_wrapJoint = function(tendon: PmjsTendon; name: PAnsiChar; coef: Double): PmjsWrap; cdecl;
  // Wrap pulley using tendon.
  Tmjs_wrapPulley = function(tendon: PmjsTendon; divisor: Double): PmjsWrap; cdecl;
  // Add numeric.
  Tmjs_addNumeric = function(s: PmjSpec): PmjsNumeric; cdecl;
  // Add text.
  Tmjs_addText = function(s: PmjSpec): PmjsText; cdecl;
  // Add tuple.
  Tmjs_addTuple = function(s: PmjSpec): PmjsTuple; cdecl;
  // Add keyframe.
  Tmjs_addKey = function(s: PmjSpec): PmjsKey; cdecl;
  // Add plugin.
  Tmjs_addPlugin = function(s: PmjSpec): PmjsPlugin; cdecl;
  // Add default.
  Tmjs_addDefault = function(s: PmjSpec; classname: PAnsiChar; parent: PmjsDefault): PmjsDefault; cdecl;
  // Set actuator to motor; return error if any.
  Tmjs_setToMotor = function(actuator: PmjsActuator): PAnsiChar; cdecl;
  // Set actuator to position; return error if any.
  Tmjs_setToPosition = function(actuator: PmjsActuator; kp: Double; kv: PmjDouble; dampratio: PmjDouble; timeconst: PmjDouble; inheritrange: Double): PAnsiChar; cdecl;
  // Set actuator to integrated velocity; return error if any.
  Tmjs_setToIntVelocity = function(actuator: PmjsActuator; kp: Double; kv: PmjDouble; dampratio: PmjDouble; timeconst: PmjDouble; inheritrange: Double): PAnsiChar; cdecl;
  // Set actuator to velocity servo; return error if any.
  Tmjs_setToVelocity = function(actuator: PmjsActuator; kv: Double): PAnsiChar; cdecl;
  // Set actuator to orientation servo.
  Tmjs_setToOrientation = function(actuator: PmjsActuator; kp: Double; kv: PmjDouble; dampratio: PmjDouble; ctrlspec: Int32): PAnsiChar; cdecl;
  // Set actuator to PID controller.
  Tmjs_setToPID = function(actuator: PmjsActuator; kp: Double; kv: PmjDouble; dampratio: PmjDouble; ki: PmjDouble; imax: PmjDouble; slewmax: PmjDouble; inheritrange: Double; ctrlspec: Int32): PAnsiChar; cdecl;
  // Set actuator to activate damper; return error if any.
  Tmjs_setToDamper = function(actuator: PmjsActuator; kv: Double): PAnsiChar; cdecl;
  // Set actuator to hydraulic or pneumatic cylinder; return error if any.
  Tmjs_setToCylinder = function(actuator: PmjsActuator; timeconst: Double; bias: Double; area: Double; diameter: Double): PAnsiChar; cdecl;
  // Set actuator to muscle; return error if any.a
  Tmjs_setToMuscle = function(actuator: PmjsActuator; timeconst: PmjDouble; tausmooth: Double; range: PmjDouble; force: Double; scale: Double; lmin: Double; lmax: Double; vmax: Double; fpmax: Double; fvmax: Double): PAnsiChar; cdecl;
  // Set actuator to active adhesion; return error if any.
  Tmjs_setToAdhesion = function(actuator: PmjsActuator; gain: Double): PAnsiChar; cdecl;
  // Set actuator to DC motor; return error if any.
  Tmjs_setToDCMotor = function(actuator: PmjsActuator; motorconst: PmjDouble; resistance: Double; nominal: PmjDouble; saturation: PmjDouble; inductance: PmjDouble; cogging: PmjDouble; controller: PmjDouble; thermal: PmjDouble; lugre: PmjDouble; ctrlspec: Int32): PAnsiChar; cdecl;
  // Add mesh.
  Tmjs_addMesh = function(s: PmjSpec; def: PmjsDefault): PmjsMesh; cdecl;
  // Add height field.
  Tmjs_addHField = function(s: PmjSpec): PmjsHField; cdecl;
  // Add skin.
  Tmjs_addSkin = function(s: PmjSpec): PmjsSkin; cdecl;
  // Add texture.
  Tmjs_addTexture = function(s: PmjSpec; def: PmjsDefault): PmjsTexture; cdecl;
  // Add material.
  Tmjs_addMaterial = function(s: PmjSpec; def: PmjsDefault): PmjsMaterial; cdecl;
  // Sets the vertices and normals of a mesh.
  Tmjs_makeMesh = function(mesh: PmjsMesh; builtin: mjtMeshBuiltin; params: PmjDouble; nparams: Int32): Int32; cdecl;
  // Get spec from body.
  Tmjs_getSpec = function(element: PmjsElement): PmjSpec; cdecl;
  // get spec that originally defined an element contrary to mjs_getSpec, this does not change after attachment
  Tmjs_getOriginSpec = function(element: PmjsElement): PmjSpec; cdecl;
  // Get compiler associated with element's origin spec.
  Tmjs_getCompiler = function(element: PmjsElement): PmjsCompiler; cdecl;
  // Find spec (model asset) by name.
  Tmjs_findSpec = function(spec: PmjSpec; name: PAnsiChar): PmjSpec; cdecl;
  // Find body in spec by name.
  Tmjs_findBody = function(s: PmjSpec; name: PAnsiChar): PmjsBody; cdecl;
  // Find element in spec by name.
  Tmjs_findElement = function(s: PmjSpec; &type: mjtObj; name: PAnsiChar): PmjsElement; cdecl;
  // Find child body by name.
  Tmjs_findChild = function(body: PmjsBody; name: PAnsiChar): PmjsBody; cdecl;
  // Get parent body.
  Tmjs_getParent = function(element: PmjsElement): PmjsBody; cdecl;
  // Get parent frame.
  Tmjs_getFrame = function(element: PmjsElement): PmjsFrame; cdecl;
  // Find frame by name.
  Tmjs_findFrame = function(s: PmjSpec; name: PAnsiChar): PmjsFrame; cdecl;
  // Get default corresponding to an element.
  Tmjs_getDefault = function(element: PmjsElement): PmjsDefault; cdecl;
  // Find default in model by class name.
  Tmjs_findDefault = function(s: PmjSpec; classname: PAnsiChar): PmjsDefault; cdecl;
  // Get global default from model.
  Tmjs_getSpecDefault = function(s: PmjSpec): PmjsDefault; cdecl;
  // Get element id.
  Tmjs_getId = function(element: PmjsElement): Int32; cdecl;
  // Return body's first child of given type. If recurse is nonzero, also search the body's subtree.
  Tmjs_firstChild = function(body: PmjsBody; &type: mjtObj; recurse: Int32): PmjsElement; cdecl;
  // Return body's next child of the same type; return NULL if child is last. If recurse is nonzero, also search the body's subtree.
  Tmjs_nextChild = function(body: PmjsBody; child: PmjsElement; recurse: Int32): PmjsElement; cdecl;
  // Return spec's first element of selected type.
  Tmjs_firstElement = function(s: PmjSpec; &type: mjtObj): PmjsElement; cdecl;
  // Return spec's next element; return NULL if element is last.
  Tmjs_nextElement = function(s: PmjSpec; element: PmjsElement): PmjsElement; cdecl;
  // Get wrapped element in tendon path.
  Tmjs_getWrapTarget = function(wrap: PmjsWrap): PmjsElement; cdecl;
  // Get wrapped element side site in tendon path if it has one, nullptr otherwise.
  Tmjs_getWrapSideSite = function(wrap: PmjsWrap): PmjsSite; cdecl;
  // Get divisor of mjsWrap wrapping a puller.
  Tmjs_getWrapDivisor = function(wrap: PmjsWrap): Double; cdecl;
  // Get coefficient of mjsWrap wrapping a joint.
  Tmjs_getWrapCoef = function(wrap: PmjsWrap): Double; cdecl;
  // Set element's name; return 0 on success.
  Tmjs_setName = function(element: PmjsElement; name: PAnsiChar): Int32; cdecl;
  // Copy buffer.
  Tmjs_setBuffer = procedure(dest: Pointer; &array: Pointer; size: Int32); cdecl;
  // Copy text to string.
  Tmjs_setString = procedure(dest: Pointer; text: PAnsiChar); cdecl;
  // Split text to entries and copy to string vector.
  Tmjs_setStringVec = procedure(dest: Pointer; text: PAnsiChar); cdecl;
  // Set entry in string vector.
  Tmjs_setInStringVec = function(dest: Pointer; i: Int32; text: PAnsiChar): mjtBool; cdecl;
  // Append text entry to string vector.
  Tmjs_appendString = procedure(dest: Pointer; text: PAnsiChar); cdecl;
  // Copy int array to vector.
  Tmjs_setInt = procedure(dest: Pointer; &array: PmjInt32; size: Int32); cdecl;
  // Append int array to vector of arrays.
  Tmjs_appendIntVec = procedure(dest: Pointer; &array: PmjInt32; size: Int32); cdecl;
  // Copy float array to vector.
  Tmjs_setFloat = procedure(dest: Pointer; &array: PmjSingle; size: Int32); cdecl;
  // Append float array to vector of arrays.
  Tmjs_appendFloatVec = procedure(dest: Pointer; &array: PmjSingle; size: Int32); cdecl;
  // Copy double array to vector.
  Tmjs_setDouble = procedure(dest: Pointer; &array: PmjDouble; size: Int32); cdecl;
  // Set plugin attributes.
  Tmjs_setPluginAttributes = procedure(plugin: PmjsPlugin; attributes: Pointer); cdecl;
  // Get element's name.
  Tmjs_getName = function(element: PmjsElement): Pointer; cdecl;
  // Get string contents.
  Tmjs_getString = function(source: Pointer): PAnsiChar; cdecl;
  // Get double array contents and optionally its size.
  Tmjs_getDouble = function(source: Pointer; size: PmjInt32): PmjDouble; cdecl;
  // Get number of elements a tendon wraps.
  Tmjs_getWrapNum = function(tendonspec: PmjsTendon): Int32; cdecl;
  // Get mjsWrap element at position i in the tendon path.
  Tmjs_getWrap = function(tendonspec: PmjsTendon; i: Int32): PmjsWrap; cdecl;
  // Get plugin attributes.
  Tmjs_getPluginAttributes = function(plugin: PmjsPlugin): Pointer; cdecl;
  // Set element's default.
  Tmjs_setDefault = procedure(element: PmjsElement; def: PmjsDefault); cdecl;
  // Set element's enclosing frame; return 0 on success.
  Tmjs_setFrame = function(dest: PmjsElement; frame: PmjsFrame): Int32; cdecl;
  // Resolve alternative orientations to quat; return error if any.
  Tmjs_resolveOrientation = function(quat: PmjDouble; degree: mjtByte; sequence: PAnsiChar; orientation: PmjsOrientation): PAnsiChar; cdecl;
  // Fuse the static bodies of the spec with their parents; return the number fused, -1 on error.
  Tmjs_fuseStatic = function(s: PmjSpec; vfs: PmjVFS): Int32; cdecl;
  // Discard the visual elements of the spec; return the number discarded, -1 on error.
  Tmjs_discardVisual = function(s: PmjSpec; vfs: PmjVFS): Int32; cdecl;
  // Merge the textures and meshes of the spec which would compile to the same asset; return the number merged, -1 on error.
  Tmjs_dedupAssets = function(s: PmjSpec): Int32; cdecl;
  // Make the inertial which compilation infers for a body part of the spec, return 0 on success.
  Tmjs_adoptInertial = function(body: PmjsBody; vfs: PmjVFS): Int32; cdecl;
  // Transform body into a frame.
  Tmjs_bodyToFrame = function(body: PPmjsBody): PmjsFrame; cdecl;
  // Set user payload, overriding the existing value for the specified key if present.
  Tmjs_setUserValue = procedure(element: PmjsElement; key: PAnsiChar; data: Pointer); cdecl;
  // Return user payload or NULL if none found.
  Tmjs_getUserValue = function(element: PmjsElement; key: PAnsiChar): Pointer; cdecl;
  // Delete user payload.
  Tmjs_deleteUserValue = procedure(element: PmjsElement; key: PAnsiChar); cdecl;
  // Return sensor dimension.
  Tmjs_sensorDim = function(sensor: PmjsSensor): Int32; cdecl;
  // Default spec attributes.
  Tmjs_defaultSpec = procedure(spec: PmjSpec); cdecl;
  // Default orientation attributes.
  Tmjs_defaultOrientation = procedure(orient: PmjsOrientation); cdecl;
  // Default body attributes.
  Tmjs_defaultBody = procedure(body: PmjsBody); cdecl;
  // Default frame attributes.
  Tmjs_defaultFrame = procedure(frame: PmjsFrame); cdecl;
  // Default joint attributes.
  Tmjs_defaultJoint = procedure(joint: PmjsJoint); cdecl;
  // Default geom attributes.
  Tmjs_defaultGeom = procedure(geom: PmjsGeom); cdecl;
  // Default site attributes.
  Tmjs_defaultSite = procedure(site: PmjsSite); cdecl;
  // Default camera attributes.
  Tmjs_defaultCamera = procedure(camera: PmjsCamera); cdecl;
  // Default light attributes.
  Tmjs_defaultLight = procedure(light: PmjsLight); cdecl;
  // Default flex attributes.
  Tmjs_defaultFlex = procedure(flex: PmjsFlex); cdecl;
  // Default mesh attributes.
  Tmjs_defaultMesh = procedure(mesh: PmjsMesh); cdecl;
  // Default height field attributes.
  Tmjs_defaultHField = procedure(hfield: PmjsHField); cdecl;
  // Default skin attributes.
  Tmjs_defaultSkin = procedure(skin: PmjsSkin); cdecl;
  // Default texture attributes.
  Tmjs_defaultTexture = procedure(texture: PmjsTexture); cdecl;
  // Default material attributes.
  Tmjs_defaultMaterial = procedure(material: PmjsMaterial); cdecl;
  // Default pair attributes.
  Tmjs_defaultPair = procedure(pair: PmjsPair); cdecl;
  // Default equality attributes.
  Tmjs_defaultEquality = procedure(equality: PmjsEquality); cdecl;
  // Default tendon attributes.
  Tmjs_defaultTendon = procedure(tendon: PmjsTendon); cdecl;
  // Default actuator attributes.
  Tmjs_defaultActuator = procedure(actuator: PmjsActuator); cdecl;
  // Default sensor attributes.
  Tmjs_defaultSensor = procedure(sensor: PmjsSensor); cdecl;
  // Default numeric attributes.
  Tmjs_defaultNumeric = procedure(numeric: PmjsNumeric); cdecl;
  // Default text attributes.
  Tmjs_defaultText = procedure(text: PmjsText); cdecl;
  // Default tuple attributes.
  Tmjs_defaultTuple = procedure(tuple: PmjsTuple); cdecl;
  // Default keyframe attributes.
  Tmjs_defaultKey = procedure(key: PmjsKey); cdecl;
  // Default plugin attributes.
  Tmjs_defaultPlugin = procedure(plugin: PmjsPlugin); cdecl;
  // Safely cast an element as mjsBody, or return NULL if the element is not an mjsBody.
  Tmjs_asBody = function(element: PmjsElement): PmjsBody; cdecl;
  // Safely cast an element as mjsGeom, or return NULL if the element is not an mjsGeom.
  Tmjs_asGeom = function(element: PmjsElement): PmjsGeom; cdecl;
  // Safely cast an element as mjsJoint, or return NULL if the element is not an mjsJoint.
  Tmjs_asJoint = function(element: PmjsElement): PmjsJoint; cdecl;
  // Safely cast an element as mjsSite, or return NULL if the element is not an mjsSite.
  Tmjs_asSite = function(element: PmjsElement): PmjsSite; cdecl;
  // Safely cast an element as mjsCamera, or return NULL if the element is not an mjsCamera.
  Tmjs_asCamera = function(element: PmjsElement): PmjsCamera; cdecl;
  // Safely cast an element as mjsLight, or return NULL if the element is not an mjsLight.
  Tmjs_asLight = function(element: PmjsElement): PmjsLight; cdecl;
  // Safely cast an element as mjsFrame, or return NULL if the element is not an mjsFrame.
  Tmjs_asFrame = function(element: PmjsElement): PmjsFrame; cdecl;
  // Safely cast an element as mjsActuator, or return NULL if the element is not an mjsActuator.
  Tmjs_asActuator = function(element: PmjsElement): PmjsActuator; cdecl;
  // Safely cast an element as mjsSensor, or return NULL if the element is not an mjsSensor.
  Tmjs_asSensor = function(element: PmjsElement): PmjsSensor; cdecl;
  // Safely cast an element as mjsFlex, or return NULL if the element is not an mjsFlex.
  Tmjs_asFlex = function(element: PmjsElement): PmjsFlex; cdecl;
  // Safely cast an element as mjsPair, or return NULL if the element is not an mjsPair.
  Tmjs_asPair = function(element: PmjsElement): PmjsPair; cdecl;
  // Safely cast an element as mjsEquality, or return NULL if the element is not an mjsEquality.
  Tmjs_asEquality = function(element: PmjsElement): PmjsEquality; cdecl;
  // Safely cast an element as mjsExclude, or return NULL if the element is not an mjsExclude.
  Tmjs_asExclude = function(element: PmjsElement): PmjsExclude; cdecl;
  // Safely cast an element as mjsTendon, or return NULL if the element is not an mjsTendon.
  Tmjs_asTendon = function(element: PmjsElement): PmjsTendon; cdecl;
  // Safely cast an element as mjsNumeric, or return NULL if the element is not an mjsNumeric.
  Tmjs_asNumeric = function(element: PmjsElement): PmjsNumeric; cdecl;
  // Safely cast an element as mjsText, or return NULL if the element is not an mjsText.
  Tmjs_asText = function(element: PmjsElement): PmjsText; cdecl;
  // Safely cast an element as mjsTuple, or return NULL if the element is not an mjsTuple.
  Tmjs_asTuple = function(element: PmjsElement): PmjsTuple; cdecl;
  // Safely cast an element as mjsKey, or return NULL if the element is not an mjsKey.
  Tmjs_asKey = function(element: PmjsElement): PmjsKey; cdecl;
  // Safely cast an element as mjsMesh, or return NULL if the element is not an mjsMesh.
  Tmjs_asMesh = function(element: PmjsElement): PmjsMesh; cdecl;
  // Safely cast an element as mjsHField, or return NULL if the element is not an mjsHField.
  Tmjs_asHField = function(element: PmjsElement): PmjsHField; cdecl;
  // Safely cast an element as mjsSkin, or return NULL if the element is not an mjsSkin.
  Tmjs_asSkin = function(element: PmjsElement): PmjsSkin; cdecl;
  // Safely cast an element as mjsTexture, or return NULL if the element is not an mjsTexture.
  Tmjs_asTexture = function(element: PmjsElement): PmjsTexture; cdecl;
  // Safely cast an element as mjsMaterial, or return NULL if the element is not an mjsMaterial.
  Tmjs_asMaterial = function(element: PmjsElement): PmjsMaterial; cdecl;
  // Safely cast an element as mjsPlugin, or return NULL if the element is not an mjsPlugin.
  Tmjs_asPlugin = function(element: PmjsElement): PmjsPlugin; cdecl;
  // Set user payload, with a cleanup function called when the element is destroyed.
  Tmjs_setUserValueWithCleanup = procedure(element: PmjsElement; key: PAnsiChar; data: Pointer; cleanup: mjfCleanup); cdecl;
  // Set default batch parameters: one thread per logical CPU, one mjData per thread.
  Tmjb_defaultConfig = procedure(config: PmjBatchConfig); cdecl;
  // Allocate a batch of nsim simulations of a copy of m; return NULL and write error on failure.
  Tmjb_makeBatch = function(m: PmjModel; nsim: Int32; config: PmjBatchConfig; error: PAnsiChar; error_sz: Int32): PmjBatch; cdecl;
  // Free a batch.
  Tmjb_deleteBatch = procedure(b: PmjBatch); cdecl;
  // Return size of a state row: mj_stateSize(m, mjSTATE_INTEGRATION).
  Tmjb_nstate = function(b: PmjBatch): Int32; cdecl;
  // Return state rows (nsim x nstate), in mj_getState order.
  Tmjb_state = function(b: PmjBatch): PmjtNum; cdecl;
  // Return address of a state component (one mjtState bit) in the first row; rows are nstate apart.
  Tmjb_stateComponent = function(b: PmjBatch; component: Int32; size: PmjInt32): PmjtNum; cdecl;
  // Return warning counters (nsim x mjNWARNING).
  Tmjb_warning = function(b: PmjBatch): PmjWarningStat; cdecl;
  // Advance simulations by nstep calls to mj_step, then compute stages up to stage (mjtStage);
  // return number of failed simulations.
  Tmjb_step = function(b: PmjBatch; ids: PmjInt32; nid: Int32; nstep: Int32; stage: Int32): Int32; cdecl;
  // Compute stages up to stage (mjtStage) on simulations; return number of failed simulations.
  Tmjb_forward = function(b: PmjBatch; ids: PmjInt32; nid: Int32; stage: Int32): Int32; cdecl;
  // Reset simulations to keyframes (key, per simulation; -1 or NULL: defaults), then compute stages;
  // return number failed.
  Tmjb_reset = function(b: PmjBatch; ids: PmjInt32; nid: Int32; key: PmjInt32; stage: Int32): Int32; cdecl;
  // Return status of each simulation's last call (nsim): nonzero if it raised an error.
  Tmjb_status = function(b: PmjBatch): PmjInt32; cdecl;
  // Return error message of simulation's last call, or "" if none.
  Tmjb_error = function(b: PmjBatch; sim: Int32): PAnsiChar; cdecl;
  // Copy mjData field out after every call; return its storage (nsim x size), NULL if invalid.
  Tmjb_output = function(b: PmjBatch; name: PAnsiChar; size: PmjInt32; elemsize: PmjInt32): Pointer; cdecl;
  // Give mjModel field per-simulation values; return its storage (nsim x size), NULL if invalid.
  Tmjb_expand = function(b: PmjBatch; name: PAnsiChar; size: PmjInt32; elemsize: PmjInt32): Pointer; cdecl;
  // Return storage (nsim x size) of mjModel field if expanded, without expanding it; NULL if not.
  Tmjb_expanded = function(b: PmjBatch; name: PAnsiChar; size: PmjInt32; elemsize: PmjInt32): Pointer; cdecl;
  // Run mj_setConst on each simulation's model; return number of failed simulations.
  Tmjb_setConst = function(b: PmjBatch; ids: PmjInt32; nid: Int32): Int32; cdecl;
  // Run simulation i on models[i], the caller's, instead of the batch's model; NULL: the batch's.
  Tmjb_setModels = procedure(b: PmjBatch; models: PPmjModel); cdecl;
  // Advance simulations with per-substep controls and records; return number failed.
  Tmjb_rollout = function(b: PmjBatch; ids: PmjInt32; nid: Int32; nstep: Int32; control: PmjtNum; control_spec: Int32; &record: PmjBatchRecord; nrecord: Int32): Int32; cdecl;
  // Run func on each simulation, saving the state if save is nonzero; return number failed.
  Tmjb_apply = function(b: PmjBatch; ids: PmjInt32; nid: Int32; func: mjfBatchFunc; arg: Pointer; save: Int32): Int32; cdecl;
  // Write simulation sim's model into m, which has the batch's sizes, such as a copy of mjb_model.
  Tmjb_getModel = procedure(b: PmjBatch; sim: Int32; m: PmjModel); cdecl;
  // Write simulation sim's state into d, which has the batch's sizes; persistent: its whole mjData.
  Tmjb_getData = procedure(b: PmjBatch; sim: Int32; d: PmjData); cdecl;
  // Return number of simulations.
  Tmjb_nsim = function(b: PmjBatch): Int32; cdecl;
  // Return number of threads, including the caller's.
  Tmjb_nthread = function(b: PmjBatch): Int32; cdecl;
  // Return 1 if the batch keeps one mjData per simulation, 0 otherwise.
  Tmjb_persistent = function(b: PmjBatch): Int32; cdecl;
  // Return the batch's copy of the model.
  Tmjb_model = function(b: PmjBatch): PmjModel; cdecl;

var
  //---------------------------------------------------------------------------
  // API functions (nil until LoadMuJoCoLibrary succeeds)

  mj_defaultVFS: Tmj_defaultVFS = nil;
  mj_mountVFS: Tmj_mountVFS = nil;
  mj_unmountVFS: Tmj_unmountVFS = nil;
  mj_addFileVFS: Tmj_addFileVFS = nil;
  mj_addBufferVFS: Tmj_addBufferVFS = nil;
  mj_deleteFileVFS: Tmj_deleteFileVFS = nil;
  mj_containsBufferVFS: Tmj_containsBufferVFS = nil;
  mj_containsFileVFS: Tmj_containsFileVFS = nil;
  mj_deleteVFS: Tmj_deleteVFS = nil;
  mj_getCacheSize: Tmj_getCacheSize = nil;
  mj_getCacheCapacity: Tmj_getCacheCapacity = nil;
  mj_setCacheCapacity: Tmj_setCacheCapacity = nil;
  mj_getCache: Tmj_getCache = nil;
  mj_clearCache: Tmj_clearCache = nil;
  mj_loadXML: Tmj_loadXML = nil;
  mj_parseXML: Tmj_parseXML = nil;
  mj_parseXMLString: Tmj_parseXMLString = nil;
  mj_parse: Tmj_parse = nil;
  mj_encode: Tmj_encode = nil;
  mj_compile: Tmj_compile = nil;
  mj_copyBack: Tmj_copyBack = nil;
  mj_recompile: Tmj_recompile = nil;
  mj_loadTexture: Tmj_loadTexture = nil;
  mj_embedAssets: Tmj_embedAssets = nil;
  mj_saveLastXML: Tmj_saveLastXML = nil;
  mj_freeLastXML: Tmj_freeLastXML = nil;
  mj_saveXMLString: Tmj_saveXMLString = nil;
  mj_saveXML: Tmj_saveXML = nil;
  mju_getXMLDependencies: Tmju_getXMLDependencies = nil;
  mj_step: Tmj_step = nil;
  mj_step1: Tmj_step1 = nil;
  mj_step2: Tmj_step2 = nil;
  mj_forward: Tmj_forward = nil;
  mj_inverse: Tmj_inverse = nil;
  mj_forwardSkip: Tmj_forwardSkip = nil;
  mj_inverseSkip: Tmj_inverseSkip = nil;
  mj_defaultLROpt: Tmj_defaultLROpt = nil;
  mj_defaultSolRefImp: Tmj_defaultSolRefImp = nil;
  mj_defaultOption: Tmj_defaultOption = nil;
  mj_defaultVisual: Tmj_defaultVisual = nil;
  mj_copyModel: Tmj_copyModel = nil;
  mj_saveModel: Tmj_saveModel = nil;
  mj_loadModel: Tmj_loadModel = nil;
  mj_loadModelBuffer: Tmj_loadModelBuffer = nil;
  mj_deleteModel: Tmj_deleteModel = nil;
  mj_sizeModel: Tmj_sizeModel = nil;
  mj_makeData: Tmj_makeData = nil;
  mj_copyData: Tmj_copyData = nil;
  mjv_copyData: Tmjv_copyData = nil;
  mj_resetCtrl: Tmj_resetCtrl = nil;
  mj_resetData: Tmj_resetData = nil;
  mj_resetDataDebug: Tmj_resetDataDebug = nil;
  mj_resetDataKeyframe: Tmj_resetDataKeyframe = nil;
  mj_markStack: Tmj_markStack = nil;
  mj_freeStack: Tmj_freeStack = nil;
  mj_stackAllocByte: Tmj_stackAllocByte = nil;
  mj_stackAllocNum: Tmj_stackAllocNum = nil;
  mj_stackAllocInt: Tmj_stackAllocInt = nil;
  mj_deleteData: Tmj_deleteData = nil;
  mj_resetCallbacks: Tmj_resetCallbacks = nil;
  mj_setConst: Tmj_setConst = nil;
  mj_setLengthRange: Tmj_setLengthRange = nil;
  mj_makeSpec: Tmj_makeSpec = nil;
  mj_copySpec: Tmj_copySpec = nil;
  mj_deleteSpec: Tmj_deleteSpec = nil;
  mjs_activatePlugin: Tmjs_activatePlugin = nil;
  mjs_setDeepCopy: Tmjs_setDeepCopy = nil;
  mj_printFormattedModel: Tmj_printFormattedModel = nil;
  mj_printModel: Tmj_printModel = nil;
  mj_printFormattedData: Tmj_printFormattedData = nil;
  mj_printData: Tmj_printData = nil;
  mju_printMat: Tmju_printMat = nil;
  mju_printMatSparse: Tmju_printMatSparse = nil;
  mj_printSchema: Tmj_printSchema = nil;
  mj_printScene: Tmj_printScene = nil;
  mj_printFormattedScene: Tmj_printFormattedScene = nil;
  mj_fwdKinematics: Tmj_fwdKinematics = nil;
  mj_fwdPosition: Tmj_fwdPosition = nil;
  mj_fwdVelocity: Tmj_fwdVelocity = nil;
  mj_fwdActuation: Tmj_fwdActuation = nil;
  mj_fwdAcceleration: Tmj_fwdAcceleration = nil;
  mj_fwdConstraint: Tmj_fwdConstraint = nil;
  mj_Euler: Tmj_Euler = nil;
  mj_RungeKutta: Tmj_RungeKutta = nil;
  mj_implicit: Tmj_implicit = nil;
  mj_invPosition: Tmj_invPosition = nil;
  mj_invVelocity: Tmj_invVelocity = nil;
  mj_invConstraint: Tmj_invConstraint = nil;
  mj_compareFwdInv: Tmj_compareFwdInv = nil;
  mj_sensorPos: Tmj_sensorPos = nil;
  mj_sensorVel: Tmj_sensorVel = nil;
  mj_sensorAcc: Tmj_sensorAcc = nil;
  mj_energyPos: Tmj_energyPos = nil;
  mj_energyVel: Tmj_energyVel = nil;
  mj_checkPos: Tmj_checkPos = nil;
  mj_checkVel: Tmj_checkVel = nil;
  mj_checkAcc: Tmj_checkAcc = nil;
  mj_kinematics: Tmj_kinematics = nil;
  mj_comPos: Tmj_comPos = nil;
  mj_camlight: Tmj_camlight = nil;
  mj_flex: Tmj_flex = nil;
  mj_tendon: Tmj_tendon = nil;
  mj_transmission: Tmj_transmission = nil;
  mj_crb: Tmj_crb = nil;
  mj_makeM: Tmj_makeM = nil;
  mj_factorM: Tmj_factorM = nil;
  mj_solveM: Tmj_solveM = nil;
  mj_solveM2: Tmj_solveM2 = nil;
  mj_comVel: Tmj_comVel = nil;
  mj_passive: Tmj_passive = nil;
  mj_subtreeVel: Tmj_subtreeVel = nil;
  mj_rne: Tmj_rne = nil;
  mj_rnePostConstraint: Tmj_rnePostConstraint = nil;
  mj_maxContact: Tmj_maxContact = nil;
  mj_collision: Tmj_collision = nil;
  mj_makeConstraint: Tmj_makeConstraint = nil;
  mj_island: Tmj_island = nil;
  mj_projectConstraint: Tmj_projectConstraint = nil;
  mj_referenceConstraint: Tmj_referenceConstraint = nil;
  mj_constraintUpdate: Tmj_constraintUpdate = nil;
  mj_stateSize: Tmj_stateSize = nil;
  mj_getState: Tmj_getState = nil;
  mj_extractState: Tmj_extractState = nil;
  mj_setState: Tmj_setState = nil;
  mj_copyState: Tmj_copyState = nil;
  mj_readCtrl: Tmj_readCtrl = nil;
  mj_readSensor: Tmj_readSensor = nil;
  mj_initCtrlHistory: Tmj_initCtrlHistory = nil;
  mj_initSensorHistory: Tmj_initSensorHistory = nil;
  mj_setKeyframe: Tmj_setKeyframe = nil;
  mj_addContact: Tmj_addContact = nil;
  mj_isPyramidal: Tmj_isPyramidal = nil;
  mj_isSparse: Tmj_isSparse = nil;
  mj_isDual: Tmj_isDual = nil;
  mj_mulJacVec: Tmj_mulJacVec = nil;
  mj_mulJacTVec: Tmj_mulJacTVec = nil;
  mj_jac: Tmj_jac = nil;
  mj_jacBody: Tmj_jacBody = nil;
  mj_jacBodyCom: Tmj_jacBodyCom = nil;
  mj_jacSubtreeCom: Tmj_jacSubtreeCom = nil;
  mj_jacGeom: Tmj_jacGeom = nil;
  mj_jacSite: Tmj_jacSite = nil;
  mj_jacPointAxis: Tmj_jacPointAxis = nil;
  mj_jacDot: Tmj_jacDot = nil;
  mj_angmomMat: Tmj_angmomMat = nil;
  mj_name2id: Tmj_name2id = nil;
  mj_id2name: Tmj_id2name = nil;
  mj_actuatorInputName: Tmj_actuatorInputName = nil;
  mj_fullM: Tmj_fullM = nil;
  mj_mulM: Tmj_mulM = nil;
  mj_mulM2: Tmj_mulM2 = nil;
  mj_addM: Tmj_addM = nil;
  mj_applyFT: Tmj_applyFT = nil;
  mj_objectVelocity: Tmj_objectVelocity = nil;
  mj_objectAcceleration: Tmj_objectAcceleration = nil;
  mj_geomDistance: Tmj_geomDistance = nil;
  mj_insideSite: Tmj_insideSite = nil;
  mj_contactForce: Tmj_contactForce = nil;
  mj_differentiatePos: Tmj_differentiatePos = nil;
  mj_integratePos: Tmj_integratePos = nil;
  mj_normalizeQuat: Tmj_normalizeQuat = nil;
  mj_local2Global: Tmj_local2Global = nil;
  mj_getTotalmass: Tmj_getTotalmass = nil;
  mj_setTotalmass: Tmj_setTotalmass = nil;
  mj_getPluginConfig: Tmj_getPluginConfig = nil;
  mj_loadPluginLibrary: Tmj_loadPluginLibrary = nil;
  mj_loadAllPluginLibraries: Tmj_loadAllPluginLibraries = nil;
  mj_version: Tmj_version = nil;
  mj_versionString: Tmj_versionString = nil;
  mj_ray: Tmj_ray = nil;
  mj_multiRay: Tmj_multiRay = nil;
  mj_rayHfield: Tmj_rayHfield = nil;
  mj_rayMesh: Tmj_rayMesh = nil;
  mju_rayGeom: Tmju_rayGeom = nil;
  mj_rayFlex: Tmj_rayFlex = nil;
  mju_raySkin: Tmju_raySkin = nil;
  mjv_defaultCamera: Tmjv_defaultCamera = nil;
  mjv_defaultFreeCamera: Tmjv_defaultFreeCamera = nil;
  mjv_defaultPerturb: Tmjv_defaultPerturb = nil;
  mjv_room2model: Tmjv_room2model = nil;
  mjv_model2room: Tmjv_model2room = nil;
  mjv_cameraInModel: Tmjv_cameraInModel = nil;
  mjv_cameraInRoom: Tmjv_cameraInRoom = nil;
  mjv_frustumHeight: Tmjv_frustumHeight = nil;
  mjv_alignToCamera: Tmjv_alignToCamera = nil;
  mjv_moveCamera: Tmjv_moveCamera = nil;
  mjv_movePerturb: Tmjv_movePerturb = nil;
  mjv_moveModel: Tmjv_moveModel = nil;
  mjv_initPerturb: Tmjv_initPerturb = nil;
  mjv_applyPerturbPose: Tmjv_applyPerturbPose = nil;
  mjv_applyPerturbForce: Tmjv_applyPerturbForce = nil;
  mjv_averageCamera: Tmjv_averageCamera = nil;
  mjv_camera2GLCamera: Tmjv_camera2GLCamera = nil;
  mjv_select: Tmjv_select = nil;
  mjv_defaultOption: Tmjv_defaultOption = nil;
  mjv_defaultFigure: Tmjv_defaultFigure = nil;
  mjv_initGeom: Tmjv_initGeom = nil;
  mjv_connector: Tmjv_connector = nil;
  mjv_defaultScene: Tmjv_defaultScene = nil;
  mjv_makeScene: Tmjv_makeScene = nil;
  mjv_freeScene: Tmjv_freeScene = nil;
  mjv_updateScene: Tmjv_updateScene = nil;
  mjv_copyModel: Tmjv_copyModel = nil;
  mjv_addGeoms: Tmjv_addGeoms = nil;
  mjv_makeLights: Tmjv_makeLights = nil;
  mjv_updateCamera: Tmjv_updateCamera = nil;
  mjv_updateSkin: Tmjv_updateSkin = nil;
  mjv_cameraFrame: Tmjv_cameraFrame = nil;
  mjv_cameraFrustum: Tmjv_cameraFrustum = nil;
  mjr_defaultContext: Tmjr_defaultContext = nil;
  mjr_defaultRendererInfo: Tmjr_defaultRendererInfo = nil;
  mjr_getRendererInfo: Tmjr_getRendererInfo = nil;
  mjr_makeContext: Tmjr_makeContext = nil;
  mjr_changeFont: Tmjr_changeFont = nil;
  mjr_addAux: Tmjr_addAux = nil;
  mjr_freeContext: Tmjr_freeContext = nil;
  mjr_resizeOffscreen: Tmjr_resizeOffscreen = nil;
  mjr_uploadTexture: Tmjr_uploadTexture = nil;
  mjr_uploadMesh: Tmjr_uploadMesh = nil;
  mjr_uploadHField: Tmjr_uploadHField = nil;
  mjr_restoreBuffer: Tmjr_restoreBuffer = nil;
  mjr_setBuffer: Tmjr_setBuffer = nil;
  mjr_readPixels: Tmjr_readPixels = nil;
  mjr_drawPixels: Tmjr_drawPixels = nil;
  mjr_blitBuffer: Tmjr_blitBuffer = nil;
  mjr_setAux: Tmjr_setAux = nil;
  mjr_blitAux: Tmjr_blitAux = nil;
  mjr_text: Tmjr_text = nil;
  mjr_overlay: Tmjr_overlay = nil;
  mjr_maxViewport: Tmjr_maxViewport = nil;
  mjr_rectangle: Tmjr_rectangle = nil;
  mjr_label: Tmjr_label = nil;
  mjr_figure: Tmjr_figure = nil;
  mjr_render: Tmjr_render = nil;
  mjr_finish: Tmjr_finish = nil;
  mjr_getError: Tmjr_getError = nil;
  mjr_findRect: Tmjr_findRect = nil;
  mju_error: Tmju_error = nil;
  mju_warning: Tmju_warning = nil;
  mju_clearHandlers: Tmju_clearHandlers = nil;
  mju_setLogHandler: Tmju_setLogHandler = nil;
  mju_getLogConfig: Tmju_getLogConfig = nil;
  mju_setLogConfig: Tmju_setLogConfig = nil;
  mju_info: Tmju_info = nil;
  mju_message: Tmju_message = nil;
  mju_malloc: Tmju_malloc = nil;
  mju_free: Tmju_free = nil;
  mj_warning: Tmj_warning = nil;
  mju_writeLog: Tmju_writeLog = nil;
  mjs_getError: Tmjs_getError = nil;
  mjs_getTimer: Tmjs_getTimer = nil;
  mjs_isWarning: Tmjs_isWarning = nil;
  mjs_numWarnings: Tmjs_numWarnings = nil;
  mjs_getWarning: Tmjs_getWarning = nil;
  mju_zero3: Tmju_zero3 = nil;
  mju_copy3: Tmju_copy3 = nil;
  mju_scl3: Tmju_scl3 = nil;
  mju_add3: Tmju_add3 = nil;
  mju_sub3: Tmju_sub3 = nil;
  mju_addTo3: Tmju_addTo3 = nil;
  mju_subFrom3: Tmju_subFrom3 = nil;
  mju_addToScl3: Tmju_addToScl3 = nil;
  mju_addScl3: Tmju_addScl3 = nil;
  mju_normalize3: Tmju_normalize3 = nil;
  mju_norm3: Tmju_norm3 = nil;
  mju_dot3: Tmju_dot3 = nil;
  mju_dist3: Tmju_dist3 = nil;
  mju_mulMatVec3: Tmju_mulMatVec3 = nil;
  mju_mulMatTVec3: Tmju_mulMatTVec3 = nil;
  mju_cross: Tmju_cross = nil;
  mju_zero4: Tmju_zero4 = nil;
  mju_unit4: Tmju_unit4 = nil;
  mju_copy4: Tmju_copy4 = nil;
  mju_normalize4: Tmju_normalize4 = nil;
  mju_zero: Tmju_zero = nil;
  mju_fill: Tmju_fill = nil;
  mju_copy: Tmju_copy = nil;
  mju_sum: Tmju_sum = nil;
  mju_L1: Tmju_L1 = nil;
  mju_scl: Tmju_scl = nil;
  mju_add: Tmju_add = nil;
  mju_sub: Tmju_sub = nil;
  mju_addTo: Tmju_addTo = nil;
  mju_subFrom: Tmju_subFrom = nil;
  mju_addToScl: Tmju_addToScl = nil;
  mju_addScl: Tmju_addScl = nil;
  mju_normalize: Tmju_normalize = nil;
  mju_norm: Tmju_norm = nil;
  mju_dot: Tmju_dot = nil;
  mju_mulMatVec: Tmju_mulMatVec = nil;
  mju_mulMatTVec: Tmju_mulMatTVec = nil;
  mju_mulVecMatVec: Tmju_mulVecMatVec = nil;
  mju_transpose: Tmju_transpose = nil;
  mju_symmetrize: Tmju_symmetrize = nil;
  mju_eye: Tmju_eye = nil;
  mju_mulMatMat: Tmju_mulMatMat = nil;
  mju_mulMatMatT: Tmju_mulMatMatT = nil;
  mju_mulMatTMat: Tmju_mulMatTMat = nil;
  mju_sqrMatTD: Tmju_sqrMatTD = nil;
  mju_transformSpatial: Tmju_transformSpatial = nil;
  mju_dense2sparse: Tmju_dense2sparse = nil;
  mju_sparse2dense: Tmju_sparse2dense = nil;
  mju_sym2dense: Tmju_sym2dense = nil;
  mju_rotVecQuat: Tmju_rotVecQuat = nil;
  mju_negQuat: Tmju_negQuat = nil;
  mju_mulQuat: Tmju_mulQuat = nil;
  mju_mulQuatAxis: Tmju_mulQuatAxis = nil;
  mju_axisAngle2Quat: Tmju_axisAngle2Quat = nil;
  mju_quat2Vel: Tmju_quat2Vel = nil;
  mju_subQuat: Tmju_subQuat = nil;
  mju_quat2Mat: Tmju_quat2Mat = nil;
  mju_mat2Quat: Tmju_mat2Quat = nil;
  mju_derivQuat: Tmju_derivQuat = nil;
  mju_quatIntegrate: Tmju_quatIntegrate = nil;
  mju_quatZ2Vec: Tmju_quatZ2Vec = nil;
  mju_mat2Rot: Tmju_mat2Rot = nil;
  mju_euler2Quat: Tmju_euler2Quat = nil;
  mju_mulPose: Tmju_mulPose = nil;
  mju_negPose: Tmju_negPose = nil;
  mju_trnVecPose: Tmju_trnVecPose = nil;
  mju_cholFactor: Tmju_cholFactor = nil;
  mju_cholSolve: Tmju_cholSolve = nil;
  mju_cholUpdate: Tmju_cholUpdate = nil;
  mju_cholFactorBand: Tmju_cholFactorBand = nil;
  mju_cholSolveBand: Tmju_cholSolveBand = nil;
  mju_band2Dense: Tmju_band2Dense = nil;
  mju_dense2Band: Tmju_dense2Band = nil;
  mju_bandMulMatVec: Tmju_bandMulMatVec = nil;
  mju_bandDiag: Tmju_bandDiag = nil;
  mju_eig3: Tmju_eig3 = nil;
  mju_boxQP: Tmju_boxQP = nil;
  mju_boxQPmalloc: Tmju_boxQPmalloc = nil;
  mju_muscleGain: Tmju_muscleGain = nil;
  mju_muscleBias: Tmju_muscleBias = nil;
  mju_muscleDynamics: Tmju_muscleDynamics = nil;
  mju_encodePyramid: Tmju_encodePyramid = nil;
  mju_decodePyramid: Tmju_decodePyramid = nil;
  mju_springDamper: Tmju_springDamper = nil;
  mju_min: Tmju_min = nil;
  mju_max: Tmju_max = nil;
  mju_clip: Tmju_clip = nil;
  mju_sign: Tmju_sign = nil;
  mju_round: Tmju_round = nil;
  mju_type2Str: Tmju_type2Str = nil;
  mju_str2Type: Tmju_str2Type = nil;
  mju_writeNumBytes: Tmju_writeNumBytes = nil;
  mju_warningText: Tmju_warningText = nil;
  mju_isBad: Tmju_isBad = nil;
  mju_isZero: Tmju_isZero = nil;
  mju_standardNormal: Tmju_standardNormal = nil;
  mju_f2n: Tmju_f2n = nil;
  mju_n2f: Tmju_n2f = nil;
  mju_d2n: Tmju_d2n = nil;
  mju_n2d: Tmju_n2d = nil;
  mju_insertionSort: Tmju_insertionSort = nil;
  mju_insertionSortInt: Tmju_insertionSortInt = nil;
  mju_Halton: Tmju_Halton = nil;
  mju_strncpy: Tmju_strncpy = nil;
  mju_sigmoid: Tmju_sigmoid = nil;
  mjc_getSDF: Tmjc_getSDF = nil;
  mjc_distance: Tmjc_distance = nil;
  mjc_gradient: Tmjc_gradient = nil;
  mjd_transitionFD: Tmjd_transitionFD = nil;
  mjd_inverseFD: Tmjd_inverseFD = nil;
  mjd_subQuat: Tmjd_subQuat = nil;
  mjd_quatIntegrate: Tmjd_quatIntegrate = nil;
  mjp_defaultPlugin: Tmjp_defaultPlugin = nil;
  mjp_registerPlugin: Tmjp_registerPlugin = nil;
  mjp_pluginCount: Tmjp_pluginCount = nil;
  mjp_getPlugin: Tmjp_getPlugin = nil;
  mjp_getPluginAtSlot: Tmjp_getPluginAtSlot = nil;
  mjp_defaultProvider: Tmjp_defaultProvider = nil;
  mjp_registerProvider: Tmjp_registerProvider = nil;
  mjp_providerCount: Tmjp_providerCount = nil;
  mjp_findProvider: Tmjp_findProvider = nil;
  mjp_getProviderAtSlot: Tmjp_getProviderAtSlot = nil;
  mjp_registerDecoder: Tmjp_registerDecoder = nil;
  mjp_defaultDecoder: Tmjp_defaultDecoder = nil;
  mjp_findDecoder: Tmjp_findDecoder = nil;
  mjp_registerEncoder: Tmjp_registerEncoder = nil;
  mjp_defaultEncoder: Tmjp_defaultEncoder = nil;
  mjp_findEncoder: Tmjp_findEncoder = nil;
  mjp_registerArchiveProvider: Tmjp_registerArchiveProvider = nil;
  mjp_findArchiveProvider: Tmjp_findArchiveProvider = nil;
  mjp_archiveProviderCount: Tmjp_archiveProviderCount = nil;
  mju_openResource: Tmju_openResource = nil;
  mju_closeResource: Tmju_closeResource = nil;
  mju_readResource: Tmju_readResource = nil;
  mju_writeResource: Tmju_writeResource = nil;
  mju_getResourceDir: Tmju_getResourceDir = nil;
  mju_isModifiedResource: Tmju_isModifiedResource = nil;
  mju_decodeResource: Tmju_decodeResource = nil;
  mju_threadpool: Tmju_threadpool = nil;
  mjs_attach: Tmjs_attach = nil;
  mjs_addBody: Tmjs_addBody = nil;
  mjs_addSite: Tmjs_addSite = nil;
  mjs_addJoint: Tmjs_addJoint = nil;
  mjs_addFreeJoint: Tmjs_addFreeJoint = nil;
  mjs_addGeom: Tmjs_addGeom = nil;
  mjs_addCamera: Tmjs_addCamera = nil;
  mjs_addLight: Tmjs_addLight = nil;
  mjs_addFrame: Tmjs_addFrame = nil;
  mjs_delete: Tmjs_delete = nil;
  mjs_addActuator: Tmjs_addActuator = nil;
  mjs_addSensor: Tmjs_addSensor = nil;
  mjs_addFlex: Tmjs_addFlex = nil;
  mjs_makeFlex: Tmjs_makeFlex = nil;
  mjs_addPair: Tmjs_addPair = nil;
  mjs_addExclude: Tmjs_addExclude = nil;
  mjs_addEquality: Tmjs_addEquality = nil;
  mjs_addTendon: Tmjs_addTendon = nil;
  mjs_wrapSite: Tmjs_wrapSite = nil;
  mjs_wrapGeom: Tmjs_wrapGeom = nil;
  mjs_wrapJoint: Tmjs_wrapJoint = nil;
  mjs_wrapPulley: Tmjs_wrapPulley = nil;
  mjs_addNumeric: Tmjs_addNumeric = nil;
  mjs_addText: Tmjs_addText = nil;
  mjs_addTuple: Tmjs_addTuple = nil;
  mjs_addKey: Tmjs_addKey = nil;
  mjs_addPlugin: Tmjs_addPlugin = nil;
  mjs_addDefault: Tmjs_addDefault = nil;
  mjs_setToMotor: Tmjs_setToMotor = nil;
  mjs_setToPosition: Tmjs_setToPosition = nil;
  mjs_setToIntVelocity: Tmjs_setToIntVelocity = nil;
  mjs_setToVelocity: Tmjs_setToVelocity = nil;
  mjs_setToOrientation: Tmjs_setToOrientation = nil;
  mjs_setToPID: Tmjs_setToPID = nil;
  mjs_setToDamper: Tmjs_setToDamper = nil;
  mjs_setToCylinder: Tmjs_setToCylinder = nil;
  mjs_setToMuscle: Tmjs_setToMuscle = nil;
  mjs_setToAdhesion: Tmjs_setToAdhesion = nil;
  mjs_setToDCMotor: Tmjs_setToDCMotor = nil;
  mjs_addMesh: Tmjs_addMesh = nil;
  mjs_addHField: Tmjs_addHField = nil;
  mjs_addSkin: Tmjs_addSkin = nil;
  mjs_addTexture: Tmjs_addTexture = nil;
  mjs_addMaterial: Tmjs_addMaterial = nil;
  mjs_makeMesh: Tmjs_makeMesh = nil;
  mjs_getSpec: Tmjs_getSpec = nil;
  mjs_getOriginSpec: Tmjs_getOriginSpec = nil;
  mjs_getCompiler: Tmjs_getCompiler = nil;
  mjs_findSpec: Tmjs_findSpec = nil;
  mjs_findBody: Tmjs_findBody = nil;
  mjs_findElement: Tmjs_findElement = nil;
  mjs_findChild: Tmjs_findChild = nil;
  mjs_getParent: Tmjs_getParent = nil;
  mjs_getFrame: Tmjs_getFrame = nil;
  mjs_findFrame: Tmjs_findFrame = nil;
  mjs_getDefault: Tmjs_getDefault = nil;
  mjs_findDefault: Tmjs_findDefault = nil;
  mjs_getSpecDefault: Tmjs_getSpecDefault = nil;
  mjs_getId: Tmjs_getId = nil;
  mjs_firstChild: Tmjs_firstChild = nil;
  mjs_nextChild: Tmjs_nextChild = nil;
  mjs_firstElement: Tmjs_firstElement = nil;
  mjs_nextElement: Tmjs_nextElement = nil;
  mjs_getWrapTarget: Tmjs_getWrapTarget = nil;
  mjs_getWrapSideSite: Tmjs_getWrapSideSite = nil;
  mjs_getWrapDivisor: Tmjs_getWrapDivisor = nil;
  mjs_getWrapCoef: Tmjs_getWrapCoef = nil;
  mjs_setName: Tmjs_setName = nil;
  mjs_setBuffer: Tmjs_setBuffer = nil;
  mjs_setString: Tmjs_setString = nil;
  mjs_setStringVec: Tmjs_setStringVec = nil;
  mjs_setInStringVec: Tmjs_setInStringVec = nil;
  mjs_appendString: Tmjs_appendString = nil;
  mjs_setInt: Tmjs_setInt = nil;
  mjs_appendIntVec: Tmjs_appendIntVec = nil;
  mjs_setFloat: Tmjs_setFloat = nil;
  mjs_appendFloatVec: Tmjs_appendFloatVec = nil;
  mjs_setDouble: Tmjs_setDouble = nil;
  mjs_setPluginAttributes: Tmjs_setPluginAttributes = nil;
  mjs_getName: Tmjs_getName = nil;
  mjs_getString: Tmjs_getString = nil;
  mjs_getDouble: Tmjs_getDouble = nil;
  mjs_getWrapNum: Tmjs_getWrapNum = nil;
  mjs_getWrap: Tmjs_getWrap = nil;
  mjs_getPluginAttributes: Tmjs_getPluginAttributes = nil;
  mjs_setDefault: Tmjs_setDefault = nil;
  mjs_setFrame: Tmjs_setFrame = nil;
  mjs_resolveOrientation: Tmjs_resolveOrientation = nil;
  mjs_fuseStatic: Tmjs_fuseStatic = nil;
  mjs_discardVisual: Tmjs_discardVisual = nil;
  mjs_dedupAssets: Tmjs_dedupAssets = nil;
  mjs_adoptInertial: Tmjs_adoptInertial = nil;
  mjs_bodyToFrame: Tmjs_bodyToFrame = nil;
  mjs_setUserValue: Tmjs_setUserValue = nil;
  mjs_getUserValue: Tmjs_getUserValue = nil;
  mjs_deleteUserValue: Tmjs_deleteUserValue = nil;
  mjs_sensorDim: Tmjs_sensorDim = nil;
  mjs_defaultSpec: Tmjs_defaultSpec = nil;
  mjs_defaultOrientation: Tmjs_defaultOrientation = nil;
  mjs_defaultBody: Tmjs_defaultBody = nil;
  mjs_defaultFrame: Tmjs_defaultFrame = nil;
  mjs_defaultJoint: Tmjs_defaultJoint = nil;
  mjs_defaultGeom: Tmjs_defaultGeom = nil;
  mjs_defaultSite: Tmjs_defaultSite = nil;
  mjs_defaultCamera: Tmjs_defaultCamera = nil;
  mjs_defaultLight: Tmjs_defaultLight = nil;
  mjs_defaultFlex: Tmjs_defaultFlex = nil;
  mjs_defaultMesh: Tmjs_defaultMesh = nil;
  mjs_defaultHField: Tmjs_defaultHField = nil;
  mjs_defaultSkin: Tmjs_defaultSkin = nil;
  mjs_defaultTexture: Tmjs_defaultTexture = nil;
  mjs_defaultMaterial: Tmjs_defaultMaterial = nil;
  mjs_defaultPair: Tmjs_defaultPair = nil;
  mjs_defaultEquality: Tmjs_defaultEquality = nil;
  mjs_defaultTendon: Tmjs_defaultTendon = nil;
  mjs_defaultActuator: Tmjs_defaultActuator = nil;
  mjs_defaultSensor: Tmjs_defaultSensor = nil;
  mjs_defaultNumeric: Tmjs_defaultNumeric = nil;
  mjs_defaultText: Tmjs_defaultText = nil;
  mjs_defaultTuple: Tmjs_defaultTuple = nil;
  mjs_defaultKey: Tmjs_defaultKey = nil;
  mjs_defaultPlugin: Tmjs_defaultPlugin = nil;
  mjs_asBody: Tmjs_asBody = nil;
  mjs_asGeom: Tmjs_asGeom = nil;
  mjs_asJoint: Tmjs_asJoint = nil;
  mjs_asSite: Tmjs_asSite = nil;
  mjs_asCamera: Tmjs_asCamera = nil;
  mjs_asLight: Tmjs_asLight = nil;
  mjs_asFrame: Tmjs_asFrame = nil;
  mjs_asActuator: Tmjs_asActuator = nil;
  mjs_asSensor: Tmjs_asSensor = nil;
  mjs_asFlex: Tmjs_asFlex = nil;
  mjs_asPair: Tmjs_asPair = nil;
  mjs_asEquality: Tmjs_asEquality = nil;
  mjs_asExclude: Tmjs_asExclude = nil;
  mjs_asTendon: Tmjs_asTendon = nil;
  mjs_asNumeric: Tmjs_asNumeric = nil;
  mjs_asText: Tmjs_asText = nil;
  mjs_asTuple: Tmjs_asTuple = nil;
  mjs_asKey: Tmjs_asKey = nil;
  mjs_asMesh: Tmjs_asMesh = nil;
  mjs_asHField: Tmjs_asHField = nil;
  mjs_asSkin: Tmjs_asSkin = nil;
  mjs_asTexture: Tmjs_asTexture = nil;
  mjs_asMaterial: Tmjs_asMaterial = nil;
  mjs_asPlugin: Tmjs_asPlugin = nil;
  mjs_setUserValueWithCleanup: Tmjs_setUserValueWithCleanup = nil;
  mjb_defaultConfig: Tmjb_defaultConfig = nil;
  mjb_makeBatch: Tmjb_makeBatch = nil;
  mjb_deleteBatch: Tmjb_deleteBatch = nil;
  mjb_nstate: Tmjb_nstate = nil;
  mjb_state: Tmjb_state = nil;
  mjb_stateComponent: Tmjb_stateComponent = nil;
  mjb_warning: Tmjb_warning = nil;
  mjb_step: Tmjb_step = nil;
  mjb_forward: Tmjb_forward = nil;
  mjb_reset: Tmjb_reset = nil;
  mjb_status: Tmjb_status = nil;
  mjb_error: Tmjb_error = nil;
  mjb_output: Tmjb_output = nil;
  mjb_expand: Tmjb_expand = nil;
  mjb_expanded: Tmjb_expanded = nil;
  mjb_setConst: Tmjb_setConst = nil;
  mjb_setModels: Tmjb_setModels = nil;
  mjb_rollout: Tmjb_rollout = nil;
  mjb_apply: Tmjb_apply = nil;
  mjb_getModel: Tmjb_getModel = nil;
  mjb_getData: Tmjb_getData = nil;
  mjb_nsim: Tmjb_nsim = nil;
  mjb_nthread: Tmjb_nthread = nil;
  mjb_persistent: Tmjb_persistent = nil;
  mjb_model: Tmjb_model = nil;

  //---------------------------------------------------------------------------
  // library variables (pointers into the loaded library)

  // user memory allocation and message handlers
  mju_user_malloc: ^Tmju_user_malloc = nil;
  mju_user_free: ^Tmju_user_free = nil;
  mju_user_error: ^Tmju_user_message = nil;
  mju_user_warning: ^Tmju_user_message = nil;

  // callbacks extending computation pipeline
  mjcb_passive: ^mjfGeneric = nil;
  mjcb_control: ^mjfGeneric = nil;
  mjcb_contactfilter: ^mjfConFilt = nil;
  mjcb_sensor: ^mjfSensor = nil;
  mjcb_time: ^mjfTime = nil;
  mjcb_act_dyn: ^mjfAct = nil;
  mjcb_act_gain: ^mjfAct = nil;
  mjcb_act_bias: ^mjfAct = nil;

  // collision function table
  mjCOLLISIONFUNC: ^TmjCollisionTable = nil;

  // string names
  mjDISABLESTRING: ^TmjDisableStrings = nil;
  mjENABLESTRING: ^TmjEnableStrings = nil;
  mjTIMERSTRING: ^TmjTimerStrings = nil;
  mjLABELSTRING: ^TmjLabelStrings = nil;
  mjFRAMESTRING: ^TmjFrameStrings = nil;
  mjVISSTRING: ^TmjVisStrings = nil;
  mjRNDSTRING: ^TmjRndStrings = nil;
  mjTOPICSTRING: ^TmjTopicStrings = nil;

  //---------------------------------------------------------------------------
  // loader

  // Message describing why the last LoadMuJoCoLibrary call failed.
  MuJoCoLastError: string = '';

// Load the MuJoCo shared library and resolve every entry point. Functions the
// library does not export stay nil. With ACheckVersion (the default) the
// library must report exactly mjVERSION_HEADER, because MuJoCo's struct
// layouts change between releases. Returns False and sets MuJoCoLastError on
// failure. Calling it again while loaded does nothing and returns True.
function LoadMuJoCoLibrary(const ALibraryName: string = MuJoCoLibraryName;
  ACheckVersion: Boolean = True): Boolean;

// Unload the library and reset every function pointer to nil.
procedure UnloadMuJoCoLibrary;

function MuJoCoLibraryLoaded: Boolean;

implementation

type
{$ifdef fpc}
  TMuJoCoLibHandle = TLibHandle;
{$else}
  TMuJoCoLibHandle = HMODULE;
{$endif}

var
  MuJoCoLibraryHandle: TMuJoCoLibHandle = 0;

function mjGetProc(const AName: PAnsiChar): Pointer;
begin
  if MuJoCoLibraryHandle = 0 then
    Exit(nil);
{$ifdef fpc}
  Result := GetProcedureAddress(MuJoCoLibraryHandle, AnsiString(AName));
{$else}
  Result := GetProcAddress(MuJoCoLibraryHandle, AName);
{$endif}
end;

// Resolve every entry point; with no library loaded this sets them all to nil.
procedure ResolveMuJoCoEntryPoints;
begin
  @mj_defaultVFS := mjGetProc('mj_defaultVFS');
  @mj_mountVFS := mjGetProc('mj_mountVFS');
  @mj_unmountVFS := mjGetProc('mj_unmountVFS');
  @mj_addFileVFS := mjGetProc('mj_addFileVFS');
  @mj_addBufferVFS := mjGetProc('mj_addBufferVFS');
  @mj_deleteFileVFS := mjGetProc('mj_deleteFileVFS');
  @mj_containsBufferVFS := mjGetProc('mj_containsBufferVFS');
  @mj_containsFileVFS := mjGetProc('mj_containsFileVFS');
  @mj_deleteVFS := mjGetProc('mj_deleteVFS');
  @mj_getCacheSize := mjGetProc('mj_getCacheSize');
  @mj_getCacheCapacity := mjGetProc('mj_getCacheCapacity');
  @mj_setCacheCapacity := mjGetProc('mj_setCacheCapacity');
  @mj_getCache := mjGetProc('mj_getCache');
  @mj_clearCache := mjGetProc('mj_clearCache');
  @mj_loadXML := mjGetProc('mj_loadXML');
  @mj_parseXML := mjGetProc('mj_parseXML');
  @mj_parseXMLString := mjGetProc('mj_parseXMLString');
  @mj_parse := mjGetProc('mj_parse');
  @mj_encode := mjGetProc('mj_encode');
  @mj_compile := mjGetProc('mj_compile');
  @mj_copyBack := mjGetProc('mj_copyBack');
  @mj_recompile := mjGetProc('mj_recompile');
  @mj_loadTexture := mjGetProc('mj_loadTexture');
  @mj_embedAssets := mjGetProc('mj_embedAssets');
  @mj_saveLastXML := mjGetProc('mj_saveLastXML');
  @mj_freeLastXML := mjGetProc('mj_freeLastXML');
  @mj_saveXMLString := mjGetProc('mj_saveXMLString');
  @mj_saveXML := mjGetProc('mj_saveXML');
  @mju_getXMLDependencies := mjGetProc('mju_getXMLDependencies');
  @mj_step := mjGetProc('mj_step');
  @mj_step1 := mjGetProc('mj_step1');
  @mj_step2 := mjGetProc('mj_step2');
  @mj_forward := mjGetProc('mj_forward');
  @mj_inverse := mjGetProc('mj_inverse');
  @mj_forwardSkip := mjGetProc('mj_forwardSkip');
  @mj_inverseSkip := mjGetProc('mj_inverseSkip');
  @mj_defaultLROpt := mjGetProc('mj_defaultLROpt');
  @mj_defaultSolRefImp := mjGetProc('mj_defaultSolRefImp');
  @mj_defaultOption := mjGetProc('mj_defaultOption');
  @mj_defaultVisual := mjGetProc('mj_defaultVisual');
  @mj_copyModel := mjGetProc('mj_copyModel');
  @mj_saveModel := mjGetProc('mj_saveModel');
  @mj_loadModel := mjGetProc('mj_loadModel');
  @mj_loadModelBuffer := mjGetProc('mj_loadModelBuffer');
  @mj_deleteModel := mjGetProc('mj_deleteModel');
  @mj_sizeModel := mjGetProc('mj_sizeModel');
  @mj_makeData := mjGetProc('mj_makeData');
  @mj_copyData := mjGetProc('mj_copyData');
  @mjv_copyData := mjGetProc('mjv_copyData');
  @mj_resetCtrl := mjGetProc('mj_resetCtrl');
  @mj_resetData := mjGetProc('mj_resetData');
  @mj_resetDataDebug := mjGetProc('mj_resetDataDebug');
  @mj_resetDataKeyframe := mjGetProc('mj_resetDataKeyframe');
  @mj_markStack := mjGetProc('mj_markStack');
  @mj_freeStack := mjGetProc('mj_freeStack');
  @mj_stackAllocByte := mjGetProc('mj_stackAllocByte');
  @mj_stackAllocNum := mjGetProc('mj_stackAllocNum');
  @mj_stackAllocInt := mjGetProc('mj_stackAllocInt');
  @mj_deleteData := mjGetProc('mj_deleteData');
  @mj_resetCallbacks := mjGetProc('mj_resetCallbacks');
  @mj_setConst := mjGetProc('mj_setConst');
  @mj_setLengthRange := mjGetProc('mj_setLengthRange');
  @mj_makeSpec := mjGetProc('mj_makeSpec');
  @mj_copySpec := mjGetProc('mj_copySpec');
  @mj_deleteSpec := mjGetProc('mj_deleteSpec');
  @mjs_activatePlugin := mjGetProc('mjs_activatePlugin');
  @mjs_setDeepCopy := mjGetProc('mjs_setDeepCopy');
  @mj_printFormattedModel := mjGetProc('mj_printFormattedModel');
  @mj_printModel := mjGetProc('mj_printModel');
  @mj_printFormattedData := mjGetProc('mj_printFormattedData');
  @mj_printData := mjGetProc('mj_printData');
  @mju_printMat := mjGetProc('mju_printMat');
  @mju_printMatSparse := mjGetProc('mju_printMatSparse');
  @mj_printSchema := mjGetProc('mj_printSchema');
  @mj_printScene := mjGetProc('mj_printScene');
  @mj_printFormattedScene := mjGetProc('mj_printFormattedScene');
  @mj_fwdKinematics := mjGetProc('mj_fwdKinematics');
  @mj_fwdPosition := mjGetProc('mj_fwdPosition');
  @mj_fwdVelocity := mjGetProc('mj_fwdVelocity');
  @mj_fwdActuation := mjGetProc('mj_fwdActuation');
  @mj_fwdAcceleration := mjGetProc('mj_fwdAcceleration');
  @mj_fwdConstraint := mjGetProc('mj_fwdConstraint');
  @mj_Euler := mjGetProc('mj_Euler');
  @mj_RungeKutta := mjGetProc('mj_RungeKutta');
  @mj_implicit := mjGetProc('mj_implicit');
  @mj_invPosition := mjGetProc('mj_invPosition');
  @mj_invVelocity := mjGetProc('mj_invVelocity');
  @mj_invConstraint := mjGetProc('mj_invConstraint');
  @mj_compareFwdInv := mjGetProc('mj_compareFwdInv');
  @mj_sensorPos := mjGetProc('mj_sensorPos');
  @mj_sensorVel := mjGetProc('mj_sensorVel');
  @mj_sensorAcc := mjGetProc('mj_sensorAcc');
  @mj_energyPos := mjGetProc('mj_energyPos');
  @mj_energyVel := mjGetProc('mj_energyVel');
  @mj_checkPos := mjGetProc('mj_checkPos');
  @mj_checkVel := mjGetProc('mj_checkVel');
  @mj_checkAcc := mjGetProc('mj_checkAcc');
  @mj_kinematics := mjGetProc('mj_kinematics');
  @mj_comPos := mjGetProc('mj_comPos');
  @mj_camlight := mjGetProc('mj_camlight');
  @mj_flex := mjGetProc('mj_flex');
  @mj_tendon := mjGetProc('mj_tendon');
  @mj_transmission := mjGetProc('mj_transmission');
  @mj_crb := mjGetProc('mj_crb');
  @mj_makeM := mjGetProc('mj_makeM');
  @mj_factorM := mjGetProc('mj_factorM');
  @mj_solveM := mjGetProc('mj_solveM');
  @mj_solveM2 := mjGetProc('mj_solveM2');
  @mj_comVel := mjGetProc('mj_comVel');
  @mj_passive := mjGetProc('mj_passive');
  @mj_subtreeVel := mjGetProc('mj_subtreeVel');
  @mj_rne := mjGetProc('mj_rne');
  @mj_rnePostConstraint := mjGetProc('mj_rnePostConstraint');
  @mj_maxContact := mjGetProc('mj_maxContact');
  @mj_collision := mjGetProc('mj_collision');
  @mj_makeConstraint := mjGetProc('mj_makeConstraint');
  @mj_island := mjGetProc('mj_island');
  @mj_projectConstraint := mjGetProc('mj_projectConstraint');
  @mj_referenceConstraint := mjGetProc('mj_referenceConstraint');
  @mj_constraintUpdate := mjGetProc('mj_constraintUpdate');
  @mj_stateSize := mjGetProc('mj_stateSize');
  @mj_getState := mjGetProc('mj_getState');
  @mj_extractState := mjGetProc('mj_extractState');
  @mj_setState := mjGetProc('mj_setState');
  @mj_copyState := mjGetProc('mj_copyState');
  @mj_readCtrl := mjGetProc('mj_readCtrl');
  @mj_readSensor := mjGetProc('mj_readSensor');
  @mj_initCtrlHistory := mjGetProc('mj_initCtrlHistory');
  @mj_initSensorHistory := mjGetProc('mj_initSensorHistory');
  @mj_setKeyframe := mjGetProc('mj_setKeyframe');
  @mj_addContact := mjGetProc('mj_addContact');
  @mj_isPyramidal := mjGetProc('mj_isPyramidal');
  @mj_isSparse := mjGetProc('mj_isSparse');
  @mj_isDual := mjGetProc('mj_isDual');
  @mj_mulJacVec := mjGetProc('mj_mulJacVec');
  @mj_mulJacTVec := mjGetProc('mj_mulJacTVec');
  @mj_jac := mjGetProc('mj_jac');
  @mj_jacBody := mjGetProc('mj_jacBody');
  @mj_jacBodyCom := mjGetProc('mj_jacBodyCom');
  @mj_jacSubtreeCom := mjGetProc('mj_jacSubtreeCom');
  @mj_jacGeom := mjGetProc('mj_jacGeom');
  @mj_jacSite := mjGetProc('mj_jacSite');
  @mj_jacPointAxis := mjGetProc('mj_jacPointAxis');
  @mj_jacDot := mjGetProc('mj_jacDot');
  @mj_angmomMat := mjGetProc('mj_angmomMat');
  @mj_name2id := mjGetProc('mj_name2id');
  @mj_id2name := mjGetProc('mj_id2name');
  @mj_actuatorInputName := mjGetProc('mj_actuatorInputName');
  @mj_fullM := mjGetProc('mj_fullM');
  @mj_mulM := mjGetProc('mj_mulM');
  @mj_mulM2 := mjGetProc('mj_mulM2');
  @mj_addM := mjGetProc('mj_addM');
  @mj_applyFT := mjGetProc('mj_applyFT');
  @mj_objectVelocity := mjGetProc('mj_objectVelocity');
  @mj_objectAcceleration := mjGetProc('mj_objectAcceleration');
  @mj_geomDistance := mjGetProc('mj_geomDistance');
  @mj_insideSite := mjGetProc('mj_insideSite');
  @mj_contactForce := mjGetProc('mj_contactForce');
  @mj_differentiatePos := mjGetProc('mj_differentiatePos');
  @mj_integratePos := mjGetProc('mj_integratePos');
  @mj_normalizeQuat := mjGetProc('mj_normalizeQuat');
  @mj_local2Global := mjGetProc('mj_local2Global');
  @mj_getTotalmass := mjGetProc('mj_getTotalmass');
  @mj_setTotalmass := mjGetProc('mj_setTotalmass');
  @mj_getPluginConfig := mjGetProc('mj_getPluginConfig');
  @mj_loadPluginLibrary := mjGetProc('mj_loadPluginLibrary');
  @mj_loadAllPluginLibraries := mjGetProc('mj_loadAllPluginLibraries');
  @mj_version := mjGetProc('mj_version');
  @mj_versionString := mjGetProc('mj_versionString');
  @mj_ray := mjGetProc('mj_ray');
  @mj_multiRay := mjGetProc('mj_multiRay');
  @mj_rayHfield := mjGetProc('mj_rayHfield');
  @mj_rayMesh := mjGetProc('mj_rayMesh');
  @mju_rayGeom := mjGetProc('mju_rayGeom');
  @mj_rayFlex := mjGetProc('mj_rayFlex');
  @mju_raySkin := mjGetProc('mju_raySkin');
  @mjv_defaultCamera := mjGetProc('mjv_defaultCamera');
  @mjv_defaultFreeCamera := mjGetProc('mjv_defaultFreeCamera');
  @mjv_defaultPerturb := mjGetProc('mjv_defaultPerturb');
  @mjv_room2model := mjGetProc('mjv_room2model');
  @mjv_model2room := mjGetProc('mjv_model2room');
  @mjv_cameraInModel := mjGetProc('mjv_cameraInModel');
  @mjv_cameraInRoom := mjGetProc('mjv_cameraInRoom');
  @mjv_frustumHeight := mjGetProc('mjv_frustumHeight');
  @mjv_alignToCamera := mjGetProc('mjv_alignToCamera');
  @mjv_moveCamera := mjGetProc('mjv_moveCamera');
  @mjv_movePerturb := mjGetProc('mjv_movePerturb');
  @mjv_moveModel := mjGetProc('mjv_moveModel');
  @mjv_initPerturb := mjGetProc('mjv_initPerturb');
  @mjv_applyPerturbPose := mjGetProc('mjv_applyPerturbPose');
  @mjv_applyPerturbForce := mjGetProc('mjv_applyPerturbForce');
  @mjv_averageCamera := mjGetProc('mjv_averageCamera');
  @mjv_camera2GLCamera := mjGetProc('mjv_camera2GLCamera');
  @mjv_select := mjGetProc('mjv_select');
  @mjv_defaultOption := mjGetProc('mjv_defaultOption');
  @mjv_defaultFigure := mjGetProc('mjv_defaultFigure');
  @mjv_initGeom := mjGetProc('mjv_initGeom');
  @mjv_connector := mjGetProc('mjv_connector');
  @mjv_defaultScene := mjGetProc('mjv_defaultScene');
  @mjv_makeScene := mjGetProc('mjv_makeScene');
  @mjv_freeScene := mjGetProc('mjv_freeScene');
  @mjv_updateScene := mjGetProc('mjv_updateScene');
  @mjv_copyModel := mjGetProc('mjv_copyModel');
  @mjv_addGeoms := mjGetProc('mjv_addGeoms');
  @mjv_makeLights := mjGetProc('mjv_makeLights');
  @mjv_updateCamera := mjGetProc('mjv_updateCamera');
  @mjv_updateSkin := mjGetProc('mjv_updateSkin');
  @mjv_cameraFrame := mjGetProc('mjv_cameraFrame');
  @mjv_cameraFrustum := mjGetProc('mjv_cameraFrustum');
  @mjr_defaultContext := mjGetProc('mjr_defaultContext');
  @mjr_defaultRendererInfo := mjGetProc('mjr_defaultRendererInfo');
  @mjr_getRendererInfo := mjGetProc('mjr_getRendererInfo');
  @mjr_makeContext := mjGetProc('mjr_makeContext');
  @mjr_changeFont := mjGetProc('mjr_changeFont');
  @mjr_addAux := mjGetProc('mjr_addAux');
  @mjr_freeContext := mjGetProc('mjr_freeContext');
  @mjr_resizeOffscreen := mjGetProc('mjr_resizeOffscreen');
  @mjr_uploadTexture := mjGetProc('mjr_uploadTexture');
  @mjr_uploadMesh := mjGetProc('mjr_uploadMesh');
  @mjr_uploadHField := mjGetProc('mjr_uploadHField');
  @mjr_restoreBuffer := mjGetProc('mjr_restoreBuffer');
  @mjr_setBuffer := mjGetProc('mjr_setBuffer');
  @mjr_readPixels := mjGetProc('mjr_readPixels');
  @mjr_drawPixels := mjGetProc('mjr_drawPixels');
  @mjr_blitBuffer := mjGetProc('mjr_blitBuffer');
  @mjr_setAux := mjGetProc('mjr_setAux');
  @mjr_blitAux := mjGetProc('mjr_blitAux');
  @mjr_text := mjGetProc('mjr_text');
  @mjr_overlay := mjGetProc('mjr_overlay');
  @mjr_maxViewport := mjGetProc('mjr_maxViewport');
  @mjr_rectangle := mjGetProc('mjr_rectangle');
  @mjr_label := mjGetProc('mjr_label');
  @mjr_figure := mjGetProc('mjr_figure');
  @mjr_render := mjGetProc('mjr_render');
  @mjr_finish := mjGetProc('mjr_finish');
  @mjr_getError := mjGetProc('mjr_getError');
  @mjr_findRect := mjGetProc('mjr_findRect');
  @mju_error := mjGetProc('mju_error');
  @mju_warning := mjGetProc('mju_warning');
  @mju_clearHandlers := mjGetProc('mju_clearHandlers');
  @mju_setLogHandler := mjGetProc('mju_setLogHandler');
  @mju_getLogConfig := mjGetProc('mju_getLogConfig');
  @mju_setLogConfig := mjGetProc('mju_setLogConfig');
  @mju_info := mjGetProc('mju_info');
  @mju_message := mjGetProc('mju_message');
  @mju_malloc := mjGetProc('mju_malloc');
  @mju_free := mjGetProc('mju_free');
  @mj_warning := mjGetProc('mj_warning');
  @mju_writeLog := mjGetProc('mju_writeLog');
  @mjs_getError := mjGetProc('mjs_getError');
  @mjs_getTimer := mjGetProc('mjs_getTimer');
  @mjs_isWarning := mjGetProc('mjs_isWarning');
  @mjs_numWarnings := mjGetProc('mjs_numWarnings');
  @mjs_getWarning := mjGetProc('mjs_getWarning');
  @mju_zero3 := mjGetProc('mju_zero3');
  @mju_copy3 := mjGetProc('mju_copy3');
  @mju_scl3 := mjGetProc('mju_scl3');
  @mju_add3 := mjGetProc('mju_add3');
  @mju_sub3 := mjGetProc('mju_sub3');
  @mju_addTo3 := mjGetProc('mju_addTo3');
  @mju_subFrom3 := mjGetProc('mju_subFrom3');
  @mju_addToScl3 := mjGetProc('mju_addToScl3');
  @mju_addScl3 := mjGetProc('mju_addScl3');
  @mju_normalize3 := mjGetProc('mju_normalize3');
  @mju_norm3 := mjGetProc('mju_norm3');
  @mju_dot3 := mjGetProc('mju_dot3');
  @mju_dist3 := mjGetProc('mju_dist3');
  @mju_mulMatVec3 := mjGetProc('mju_mulMatVec3');
  @mju_mulMatTVec3 := mjGetProc('mju_mulMatTVec3');
  @mju_cross := mjGetProc('mju_cross');
  @mju_zero4 := mjGetProc('mju_zero4');
  @mju_unit4 := mjGetProc('mju_unit4');
  @mju_copy4 := mjGetProc('mju_copy4');
  @mju_normalize4 := mjGetProc('mju_normalize4');
  @mju_zero := mjGetProc('mju_zero');
  @mju_fill := mjGetProc('mju_fill');
  @mju_copy := mjGetProc('mju_copy');
  @mju_sum := mjGetProc('mju_sum');
  @mju_L1 := mjGetProc('mju_L1');
  @mju_scl := mjGetProc('mju_scl');
  @mju_add := mjGetProc('mju_add');
  @mju_sub := mjGetProc('mju_sub');
  @mju_addTo := mjGetProc('mju_addTo');
  @mju_subFrom := mjGetProc('mju_subFrom');
  @mju_addToScl := mjGetProc('mju_addToScl');
  @mju_addScl := mjGetProc('mju_addScl');
  @mju_normalize := mjGetProc('mju_normalize');
  @mju_norm := mjGetProc('mju_norm');
  @mju_dot := mjGetProc('mju_dot');
  @mju_mulMatVec := mjGetProc('mju_mulMatVec');
  @mju_mulMatTVec := mjGetProc('mju_mulMatTVec');
  @mju_mulVecMatVec := mjGetProc('mju_mulVecMatVec');
  @mju_transpose := mjGetProc('mju_transpose');
  @mju_symmetrize := mjGetProc('mju_symmetrize');
  @mju_eye := mjGetProc('mju_eye');
  @mju_mulMatMat := mjGetProc('mju_mulMatMat');
  @mju_mulMatMatT := mjGetProc('mju_mulMatMatT');
  @mju_mulMatTMat := mjGetProc('mju_mulMatTMat');
  @mju_sqrMatTD := mjGetProc('mju_sqrMatTD');
  @mju_transformSpatial := mjGetProc('mju_transformSpatial');
  @mju_dense2sparse := mjGetProc('mju_dense2sparse');
  @mju_sparse2dense := mjGetProc('mju_sparse2dense');
  @mju_sym2dense := mjGetProc('mju_sym2dense');
  @mju_rotVecQuat := mjGetProc('mju_rotVecQuat');
  @mju_negQuat := mjGetProc('mju_negQuat');
  @mju_mulQuat := mjGetProc('mju_mulQuat');
  @mju_mulQuatAxis := mjGetProc('mju_mulQuatAxis');
  @mju_axisAngle2Quat := mjGetProc('mju_axisAngle2Quat');
  @mju_quat2Vel := mjGetProc('mju_quat2Vel');
  @mju_subQuat := mjGetProc('mju_subQuat');
  @mju_quat2Mat := mjGetProc('mju_quat2Mat');
  @mju_mat2Quat := mjGetProc('mju_mat2Quat');
  @mju_derivQuat := mjGetProc('mju_derivQuat');
  @mju_quatIntegrate := mjGetProc('mju_quatIntegrate');
  @mju_quatZ2Vec := mjGetProc('mju_quatZ2Vec');
  @mju_mat2Rot := mjGetProc('mju_mat2Rot');
  @mju_euler2Quat := mjGetProc('mju_euler2Quat');
  @mju_mulPose := mjGetProc('mju_mulPose');
  @mju_negPose := mjGetProc('mju_negPose');
  @mju_trnVecPose := mjGetProc('mju_trnVecPose');
  @mju_cholFactor := mjGetProc('mju_cholFactor');
  @mju_cholSolve := mjGetProc('mju_cholSolve');
  @mju_cholUpdate := mjGetProc('mju_cholUpdate');
  @mju_cholFactorBand := mjGetProc('mju_cholFactorBand');
  @mju_cholSolveBand := mjGetProc('mju_cholSolveBand');
  @mju_band2Dense := mjGetProc('mju_band2Dense');
  @mju_dense2Band := mjGetProc('mju_dense2Band');
  @mju_bandMulMatVec := mjGetProc('mju_bandMulMatVec');
  @mju_bandDiag := mjGetProc('mju_bandDiag');
  @mju_eig3 := mjGetProc('mju_eig3');
  @mju_boxQP := mjGetProc('mju_boxQP');
  @mju_boxQPmalloc := mjGetProc('mju_boxQPmalloc');
  @mju_muscleGain := mjGetProc('mju_muscleGain');
  @mju_muscleBias := mjGetProc('mju_muscleBias');
  @mju_muscleDynamics := mjGetProc('mju_muscleDynamics');
  @mju_encodePyramid := mjGetProc('mju_encodePyramid');
  @mju_decodePyramid := mjGetProc('mju_decodePyramid');
  @mju_springDamper := mjGetProc('mju_springDamper');
  @mju_min := mjGetProc('mju_min');
  @mju_max := mjGetProc('mju_max');
  @mju_clip := mjGetProc('mju_clip');
  @mju_sign := mjGetProc('mju_sign');
  @mju_round := mjGetProc('mju_round');
  @mju_type2Str := mjGetProc('mju_type2Str');
  @mju_str2Type := mjGetProc('mju_str2Type');
  @mju_writeNumBytes := mjGetProc('mju_writeNumBytes');
  @mju_warningText := mjGetProc('mju_warningText');
  @mju_isBad := mjGetProc('mju_isBad');
  @mju_isZero := mjGetProc('mju_isZero');
  @mju_standardNormal := mjGetProc('mju_standardNormal');
  @mju_f2n := mjGetProc('mju_f2n');
  @mju_n2f := mjGetProc('mju_n2f');
  @mju_d2n := mjGetProc('mju_d2n');
  @mju_n2d := mjGetProc('mju_n2d');
  @mju_insertionSort := mjGetProc('mju_insertionSort');
  @mju_insertionSortInt := mjGetProc('mju_insertionSortInt');
  @mju_Halton := mjGetProc('mju_Halton');
  @mju_strncpy := mjGetProc('mju_strncpy');
  @mju_sigmoid := mjGetProc('mju_sigmoid');
  @mjc_getSDF := mjGetProc('mjc_getSDF');
  @mjc_distance := mjGetProc('mjc_distance');
  @mjc_gradient := mjGetProc('mjc_gradient');
  @mjd_transitionFD := mjGetProc('mjd_transitionFD');
  @mjd_inverseFD := mjGetProc('mjd_inverseFD');
  @mjd_subQuat := mjGetProc('mjd_subQuat');
  @mjd_quatIntegrate := mjGetProc('mjd_quatIntegrate');
  @mjp_defaultPlugin := mjGetProc('mjp_defaultPlugin');
  @mjp_registerPlugin := mjGetProc('mjp_registerPlugin');
  @mjp_pluginCount := mjGetProc('mjp_pluginCount');
  @mjp_getPlugin := mjGetProc('mjp_getPlugin');
  @mjp_getPluginAtSlot := mjGetProc('mjp_getPluginAtSlot');
  @mjp_defaultProvider := mjGetProc('mjp_defaultProvider');
  @mjp_registerProvider := mjGetProc('mjp_registerProvider');
  @mjp_providerCount := mjGetProc('mjp_providerCount');
  @mjp_findProvider := mjGetProc('mjp_findProvider');
  @mjp_getProviderAtSlot := mjGetProc('mjp_getProviderAtSlot');
  @mjp_registerDecoder := mjGetProc('mjp_registerDecoder');
  @mjp_defaultDecoder := mjGetProc('mjp_defaultDecoder');
  @mjp_findDecoder := mjGetProc('mjp_findDecoder');
  @mjp_registerEncoder := mjGetProc('mjp_registerEncoder');
  @mjp_defaultEncoder := mjGetProc('mjp_defaultEncoder');
  @mjp_findEncoder := mjGetProc('mjp_findEncoder');
  @mjp_registerArchiveProvider := mjGetProc('mjp_registerArchiveProvider');
  @mjp_findArchiveProvider := mjGetProc('mjp_findArchiveProvider');
  @mjp_archiveProviderCount := mjGetProc('mjp_archiveProviderCount');
  @mju_openResource := mjGetProc('mju_openResource');
  @mju_closeResource := mjGetProc('mju_closeResource');
  @mju_readResource := mjGetProc('mju_readResource');
  @mju_writeResource := mjGetProc('mju_writeResource');
  @mju_getResourceDir := mjGetProc('mju_getResourceDir');
  @mju_isModifiedResource := mjGetProc('mju_isModifiedResource');
  @mju_decodeResource := mjGetProc('mju_decodeResource');
  @mju_threadpool := mjGetProc('mju_threadpool');
  @mjs_attach := mjGetProc('mjs_attach');
  @mjs_addBody := mjGetProc('mjs_addBody');
  @mjs_addSite := mjGetProc('mjs_addSite');
  @mjs_addJoint := mjGetProc('mjs_addJoint');
  @mjs_addFreeJoint := mjGetProc('mjs_addFreeJoint');
  @mjs_addGeom := mjGetProc('mjs_addGeom');
  @mjs_addCamera := mjGetProc('mjs_addCamera');
  @mjs_addLight := mjGetProc('mjs_addLight');
  @mjs_addFrame := mjGetProc('mjs_addFrame');
  @mjs_delete := mjGetProc('mjs_delete');
  @mjs_addActuator := mjGetProc('mjs_addActuator');
  @mjs_addSensor := mjGetProc('mjs_addSensor');
  @mjs_addFlex := mjGetProc('mjs_addFlex');
  @mjs_makeFlex := mjGetProc('mjs_makeFlex');
  @mjs_addPair := mjGetProc('mjs_addPair');
  @mjs_addExclude := mjGetProc('mjs_addExclude');
  @mjs_addEquality := mjGetProc('mjs_addEquality');
  @mjs_addTendon := mjGetProc('mjs_addTendon');
  @mjs_wrapSite := mjGetProc('mjs_wrapSite');
  @mjs_wrapGeom := mjGetProc('mjs_wrapGeom');
  @mjs_wrapJoint := mjGetProc('mjs_wrapJoint');
  @mjs_wrapPulley := mjGetProc('mjs_wrapPulley');
  @mjs_addNumeric := mjGetProc('mjs_addNumeric');
  @mjs_addText := mjGetProc('mjs_addText');
  @mjs_addTuple := mjGetProc('mjs_addTuple');
  @mjs_addKey := mjGetProc('mjs_addKey');
  @mjs_addPlugin := mjGetProc('mjs_addPlugin');
  @mjs_addDefault := mjGetProc('mjs_addDefault');
  @mjs_setToMotor := mjGetProc('mjs_setToMotor');
  @mjs_setToPosition := mjGetProc('mjs_setToPosition');
  @mjs_setToIntVelocity := mjGetProc('mjs_setToIntVelocity');
  @mjs_setToVelocity := mjGetProc('mjs_setToVelocity');
  @mjs_setToOrientation := mjGetProc('mjs_setToOrientation');
  @mjs_setToPID := mjGetProc('mjs_setToPID');
  @mjs_setToDamper := mjGetProc('mjs_setToDamper');
  @mjs_setToCylinder := mjGetProc('mjs_setToCylinder');
  @mjs_setToMuscle := mjGetProc('mjs_setToMuscle');
  @mjs_setToAdhesion := mjGetProc('mjs_setToAdhesion');
  @mjs_setToDCMotor := mjGetProc('mjs_setToDCMotor');
  @mjs_addMesh := mjGetProc('mjs_addMesh');
  @mjs_addHField := mjGetProc('mjs_addHField');
  @mjs_addSkin := mjGetProc('mjs_addSkin');
  @mjs_addTexture := mjGetProc('mjs_addTexture');
  @mjs_addMaterial := mjGetProc('mjs_addMaterial');
  @mjs_makeMesh := mjGetProc('mjs_makeMesh');
  @mjs_getSpec := mjGetProc('mjs_getSpec');
  @mjs_getOriginSpec := mjGetProc('mjs_getOriginSpec');
  @mjs_getCompiler := mjGetProc('mjs_getCompiler');
  @mjs_findSpec := mjGetProc('mjs_findSpec');
  @mjs_findBody := mjGetProc('mjs_findBody');
  @mjs_findElement := mjGetProc('mjs_findElement');
  @mjs_findChild := mjGetProc('mjs_findChild');
  @mjs_getParent := mjGetProc('mjs_getParent');
  @mjs_getFrame := mjGetProc('mjs_getFrame');
  @mjs_findFrame := mjGetProc('mjs_findFrame');
  @mjs_getDefault := mjGetProc('mjs_getDefault');
  @mjs_findDefault := mjGetProc('mjs_findDefault');
  @mjs_getSpecDefault := mjGetProc('mjs_getSpecDefault');
  @mjs_getId := mjGetProc('mjs_getId');
  @mjs_firstChild := mjGetProc('mjs_firstChild');
  @mjs_nextChild := mjGetProc('mjs_nextChild');
  @mjs_firstElement := mjGetProc('mjs_firstElement');
  @mjs_nextElement := mjGetProc('mjs_nextElement');
  @mjs_getWrapTarget := mjGetProc('mjs_getWrapTarget');
  @mjs_getWrapSideSite := mjGetProc('mjs_getWrapSideSite');
  @mjs_getWrapDivisor := mjGetProc('mjs_getWrapDivisor');
  @mjs_getWrapCoef := mjGetProc('mjs_getWrapCoef');
  @mjs_setName := mjGetProc('mjs_setName');
  @mjs_setBuffer := mjGetProc('mjs_setBuffer');
  @mjs_setString := mjGetProc('mjs_setString');
  @mjs_setStringVec := mjGetProc('mjs_setStringVec');
  @mjs_setInStringVec := mjGetProc('mjs_setInStringVec');
  @mjs_appendString := mjGetProc('mjs_appendString');
  @mjs_setInt := mjGetProc('mjs_setInt');
  @mjs_appendIntVec := mjGetProc('mjs_appendIntVec');
  @mjs_setFloat := mjGetProc('mjs_setFloat');
  @mjs_appendFloatVec := mjGetProc('mjs_appendFloatVec');
  @mjs_setDouble := mjGetProc('mjs_setDouble');
  @mjs_setPluginAttributes := mjGetProc('mjs_setPluginAttributes');
  @mjs_getName := mjGetProc('mjs_getName');
  @mjs_getString := mjGetProc('mjs_getString');
  @mjs_getDouble := mjGetProc('mjs_getDouble');
  @mjs_getWrapNum := mjGetProc('mjs_getWrapNum');
  @mjs_getWrap := mjGetProc('mjs_getWrap');
  @mjs_getPluginAttributes := mjGetProc('mjs_getPluginAttributes');
  @mjs_setDefault := mjGetProc('mjs_setDefault');
  @mjs_setFrame := mjGetProc('mjs_setFrame');
  @mjs_resolveOrientation := mjGetProc('mjs_resolveOrientation');
  @mjs_fuseStatic := mjGetProc('mjs_fuseStatic');
  @mjs_discardVisual := mjGetProc('mjs_discardVisual');
  @mjs_dedupAssets := mjGetProc('mjs_dedupAssets');
  @mjs_adoptInertial := mjGetProc('mjs_adoptInertial');
  @mjs_bodyToFrame := mjGetProc('mjs_bodyToFrame');
  @mjs_setUserValue := mjGetProc('mjs_setUserValue');
  @mjs_getUserValue := mjGetProc('mjs_getUserValue');
  @mjs_deleteUserValue := mjGetProc('mjs_deleteUserValue');
  @mjs_sensorDim := mjGetProc('mjs_sensorDim');
  @mjs_defaultSpec := mjGetProc('mjs_defaultSpec');
  @mjs_defaultOrientation := mjGetProc('mjs_defaultOrientation');
  @mjs_defaultBody := mjGetProc('mjs_defaultBody');
  @mjs_defaultFrame := mjGetProc('mjs_defaultFrame');
  @mjs_defaultJoint := mjGetProc('mjs_defaultJoint');
  @mjs_defaultGeom := mjGetProc('mjs_defaultGeom');
  @mjs_defaultSite := mjGetProc('mjs_defaultSite');
  @mjs_defaultCamera := mjGetProc('mjs_defaultCamera');
  @mjs_defaultLight := mjGetProc('mjs_defaultLight');
  @mjs_defaultFlex := mjGetProc('mjs_defaultFlex');
  @mjs_defaultMesh := mjGetProc('mjs_defaultMesh');
  @mjs_defaultHField := mjGetProc('mjs_defaultHField');
  @mjs_defaultSkin := mjGetProc('mjs_defaultSkin');
  @mjs_defaultTexture := mjGetProc('mjs_defaultTexture');
  @mjs_defaultMaterial := mjGetProc('mjs_defaultMaterial');
  @mjs_defaultPair := mjGetProc('mjs_defaultPair');
  @mjs_defaultEquality := mjGetProc('mjs_defaultEquality');
  @mjs_defaultTendon := mjGetProc('mjs_defaultTendon');
  @mjs_defaultActuator := mjGetProc('mjs_defaultActuator');
  @mjs_defaultSensor := mjGetProc('mjs_defaultSensor');
  @mjs_defaultNumeric := mjGetProc('mjs_defaultNumeric');
  @mjs_defaultText := mjGetProc('mjs_defaultText');
  @mjs_defaultTuple := mjGetProc('mjs_defaultTuple');
  @mjs_defaultKey := mjGetProc('mjs_defaultKey');
  @mjs_defaultPlugin := mjGetProc('mjs_defaultPlugin');
  @mjs_asBody := mjGetProc('mjs_asBody');
  @mjs_asGeom := mjGetProc('mjs_asGeom');
  @mjs_asJoint := mjGetProc('mjs_asJoint');
  @mjs_asSite := mjGetProc('mjs_asSite');
  @mjs_asCamera := mjGetProc('mjs_asCamera');
  @mjs_asLight := mjGetProc('mjs_asLight');
  @mjs_asFrame := mjGetProc('mjs_asFrame');
  @mjs_asActuator := mjGetProc('mjs_asActuator');
  @mjs_asSensor := mjGetProc('mjs_asSensor');
  @mjs_asFlex := mjGetProc('mjs_asFlex');
  @mjs_asPair := mjGetProc('mjs_asPair');
  @mjs_asEquality := mjGetProc('mjs_asEquality');
  @mjs_asExclude := mjGetProc('mjs_asExclude');
  @mjs_asTendon := mjGetProc('mjs_asTendon');
  @mjs_asNumeric := mjGetProc('mjs_asNumeric');
  @mjs_asText := mjGetProc('mjs_asText');
  @mjs_asTuple := mjGetProc('mjs_asTuple');
  @mjs_asKey := mjGetProc('mjs_asKey');
  @mjs_asMesh := mjGetProc('mjs_asMesh');
  @mjs_asHField := mjGetProc('mjs_asHField');
  @mjs_asSkin := mjGetProc('mjs_asSkin');
  @mjs_asTexture := mjGetProc('mjs_asTexture');
  @mjs_asMaterial := mjGetProc('mjs_asMaterial');
  @mjs_asPlugin := mjGetProc('mjs_asPlugin');
  @mjs_setUserValueWithCleanup := mjGetProc('mjs_setUserValueWithCleanup');
  @mjb_defaultConfig := mjGetProc('mjb_defaultConfig');
  @mjb_makeBatch := mjGetProc('mjb_makeBatch');
  @mjb_deleteBatch := mjGetProc('mjb_deleteBatch');
  @mjb_nstate := mjGetProc('mjb_nstate');
  @mjb_state := mjGetProc('mjb_state');
  @mjb_stateComponent := mjGetProc('mjb_stateComponent');
  @mjb_warning := mjGetProc('mjb_warning');
  @mjb_step := mjGetProc('mjb_step');
  @mjb_forward := mjGetProc('mjb_forward');
  @mjb_reset := mjGetProc('mjb_reset');
  @mjb_status := mjGetProc('mjb_status');
  @mjb_error := mjGetProc('mjb_error');
  @mjb_output := mjGetProc('mjb_output');
  @mjb_expand := mjGetProc('mjb_expand');
  @mjb_expanded := mjGetProc('mjb_expanded');
  @mjb_setConst := mjGetProc('mjb_setConst');
  @mjb_setModels := mjGetProc('mjb_setModels');
  @mjb_rollout := mjGetProc('mjb_rollout');
  @mjb_apply := mjGetProc('mjb_apply');
  @mjb_getModel := mjGetProc('mjb_getModel');
  @mjb_getData := mjGetProc('mjb_getData');
  @mjb_nsim := mjGetProc('mjb_nsim');
  @mjb_nthread := mjGetProc('mjb_nthread');
  @mjb_persistent := mjGetProc('mjb_persistent');
  @mjb_model := mjGetProc('mjb_model');

  mju_user_malloc := mjGetProc('mju_user_malloc');
  mju_user_free := mjGetProc('mju_user_free');
  mju_user_error := mjGetProc('mju_user_error');
  mju_user_warning := mjGetProc('mju_user_warning');
  mjcb_passive := mjGetProc('mjcb_passive');
  mjcb_control := mjGetProc('mjcb_control');
  mjcb_contactfilter := mjGetProc('mjcb_contactfilter');
  mjcb_sensor := mjGetProc('mjcb_sensor');
  mjcb_time := mjGetProc('mjcb_time');
  mjcb_act_dyn := mjGetProc('mjcb_act_dyn');
  mjcb_act_gain := mjGetProc('mjcb_act_gain');
  mjcb_act_bias := mjGetProc('mjcb_act_bias');
  mjCOLLISIONFUNC := mjGetProc('mjCOLLISIONFUNC');
  mjDISABLESTRING := mjGetProc('mjDISABLESTRING');
  mjENABLESTRING := mjGetProc('mjENABLESTRING');
  mjTIMERSTRING := mjGetProc('mjTIMERSTRING');
  mjLABELSTRING := mjGetProc('mjLABELSTRING');
  mjFRAMESTRING := mjGetProc('mjFRAMESTRING');
  mjVISSTRING := mjGetProc('mjVISSTRING');
  mjRNDSTRING := mjGetProc('mjRNDSTRING');
  mjTOPICSTRING := mjGetProc('mjTOPICSTRING');
end;

function MuJoCoLibraryLoaded: Boolean;
begin
  Result := MuJoCoLibraryHandle <> 0;
end;

procedure UnloadMuJoCoLibrary;
begin
  if MuJoCoLibraryHandle <> 0 then
  begin
{$ifdef fpc}
    UnloadLibrary(MuJoCoLibraryHandle);
{$else}
    FreeLibrary(MuJoCoLibraryHandle);
{$endif}
    MuJoCoLibraryHandle := 0;
  end;
  ResolveMuJoCoEntryPoints;
end;

function VersionText(AVersion: Int32): string;
begin
  Result := Format('%d.%d.%d', [AVersion div 1000000, (AVersion div 1000) mod 1000,
    AVersion mod 1000]);
end;

function LoadMuJoCoLibrary(const ALibraryName: string; ACheckVersion: Boolean): Boolean;
var
  LibraryVersion: Int32;
begin
  if MuJoCoLibraryHandle <> 0 then
    Exit(True);
  MuJoCoLastError := '';
{$ifdef fpc}
  MuJoCoLibraryHandle := LoadLibrary(ALibraryName);
{$else}
  // SafeLoadLibrary restores the FPU control word the library might change
  MuJoCoLibraryHandle := SafeLoadLibrary(ALibraryName);
{$endif}
  if MuJoCoLibraryHandle = 0 then
  begin
    MuJoCoLastError := 'Could not load the MuJoCo library "' + ALibraryName + '"';
    Exit(False);
  end;
  ResolveMuJoCoEntryPoints;
  if not Assigned(mj_version) then
  begin
    MuJoCoLastError := '"' + ALibraryName + '" does not export mj_version; not a MuJoCo library';
    UnloadMuJoCoLibrary;
    Exit(False);
  end;
  LibraryVersion := mj_version();
  if ACheckVersion and (LibraryVersion <> mjVERSION_HEADER) then
  begin
    MuJoCoLastError := Format('MuJoCo library is version %s but PasMuJoCo was generated for %s',
      [VersionText(LibraryVersion), VersionText(mjVERSION_HEADER)]);
    UnloadMuJoCoLibrary;
    Exit(False);
  end;
  Result := True;
end;

end.
