{ *********************************************************************** }
{                                                                         }
{ The Siam Developer Runtime Library                                      }
{ DevCore Library                                                         }
{                                                                         }
{ Copyright (c) 2014 Siam Developer Co.,Ltd.                              }
{                                                                         }
{ *********************************************************************** }

library DevCore;
{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,SiAuto,SmartInspect,
  Classes,
  uCiaXml in '..\LIB\uCiaXml.pas',
  CommonLIB in '..\LIB\CommonLIB.pas',
  CommonUtils in '..\LIB\CommonUtils.pas',
  uDevCore in 'uDevCore.pas',
  STDLIB in '..\STDLIB\STDLIB.pas';

{$R *.res}


begin
end.
