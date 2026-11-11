{ PasMuJoCo - Object Pascal header for the MuJoCo {%VERSION_DOTTED%} C API.

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
  mjVERSION_HEADER = {%VERSION%};

  //---------------------------------------------------------------------------
  // constants

{%CONSTANTS%}

  //---------------------------------------------------------------------------
  // enum values

{%ENUM_CONSTS%}
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

{%ENUM_TYPES%}

  //---------------------------------------------------------------------------
  // opaque types (only ever used through pointers)

{%OPAQUE%}
  mjBatch = record end;

  //---------------------------------------------------------------------------
  // pointer types

{%POINTERS%}
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

{%RECORDS%}
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

{%FUNCTION_TYPES%}

var
  //---------------------------------------------------------------------------
  // API functions (nil until LoadMuJoCoLibrary succeeds)

{%FUNCTION_VARS%}

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
{%FUNCTION_LOADS%}

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
