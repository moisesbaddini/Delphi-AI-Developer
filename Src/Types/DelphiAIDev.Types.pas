unit DelphiAIDev.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo;

type
  TC4DWizardMenuContextList = procedure(const MenuContextList: IInterfaceList) of object;

  {$SCOPEDENUMS ON}
  TC4DAIsAvailable = (Gemini, OpenAI, Groq, Ollama);
  TC4DLanguage = (en, ptBR, es);
  TC4DExtensionsFiles = (None, PAS, DFM, FMX, DPR, DPK, DPROJ, ZIP, BMP, INI, ALL);
  TC4DExtensionsOfFiles = set of TC4DExtensionsFiles;
  TC4DExtensionsCommon = (rtf, csv, txt);
  TC4DIcon = (Information, Question, Warning, Error, Success);
  TC4DButtons = (OK, OK_Cancel);
  TC4DBtnFocu = (OK, Cancel);
  TC4DQuestionKind = (None, ItemMenuNormal, MenuMasterOnly, Separators);
  TC4DDriverID = (None, MySQL, Firebird);
  TAutoFreeField = (Yes, No);
  {$SCOPEDENUMS OFF}

  TC4DAIsAvailableHelper = record helper for TC4DAIsAvailable
    function ToString: string;
    function ToStringWithCreator: string;
  end;

  TC4DLanguageHelper = record helper for TC4DLanguage
    function ToString: string;
    function GetLanguageDefinition: string;
    function GetMsgCodeOnly: string;
    function GetMsgSQLOnly: string;
    function GetMsgJSONIsDatabaseStructure(ASGBDName: string): string;
    function GetMsgJSONInformedAnswerQuestion: string;
  end;

  TC4DExtensionsFilesHelper = record helper for TC4DExtensionsFiles
    function ToString: string;
    function ToStringWithPoint: string;
  end;

  TC4DExtensionsCommonHelper = record helper for TC4DExtensionsCommon
    function ToString: string;
    function ToStringWithPoint: string;
  end;

  TC4DExtensionsOfFilesHelper = record helper for TC4DExtensionsOfFiles
    function ContainsStr(const AExtension: string): Boolean;
  end;

  TC4DQuestionKindHelper = record helper for TC4DQuestionKind
    function ToString: string;
  end;

  TC4DDriverIDHelper = record helper for TC4DDriverID
    function ToString: string;
    function ToStringID: string;
  end;

implementation

uses
  DelphiAIDev.Consts;

{ TAIsAvailableHelper }
function TC4DAIsAvailableHelper.ToString: string;
begin
  case Self of
    TC4DAIsAvailable.Gemini:
      Result := 'Gemini';
    TC4DAIsAvailable.OpenAI:
      Result := 'ChatGPT';
  else
    Result := GetEnumName(TypeInfo(TC4DAIsAvailable), Integer(Self));
  end;
end;

function TC4DAIsAvailableHelper.ToStringWithCreator: string;
begin
  case Self of
    TC4DAIsAvailable.Gemini:
      Result := 'Gemini (Google)';
    TC4DAIsAvailable.OpenAI:
      Result := 'ChatGPT (OpenAI)';
  else
    Result := GetEnumName(TypeInfo(TC4DAIsAvailable), Integer(Self));
  end;
end;

{ TC4DLanguageHelper }
function TC4DLanguageHelper.ToString: string;
begin
  case Self of
    TC4DLanguage.en:
      Result := 'English';
    TC4DLanguage.ptBR:
      Result := 'Portugu�s Brasil (pt-br)';
    TC4DLanguage.es:
      Result := 'Espa�ol';
  else
    Result := GetEnumName(TypeInfo(TC4DLanguage), Integer(Self));
  end;
end;

function TC4DLanguageHelper.GetLanguageDefinition: string;
begin
  Result := 'Responda em portugu�s.' + sLineBreak;
  case Self of
    TC4DLanguage.en:
      Result := 'Answer in English.' + sLineBreak;
    TC4DLanguage.es:
      Result := 'Answer in Spanish.' + sLineBreak;
  end;
end;

function TC4DLanguageHelper.GetMsgCodeOnly: string;
begin
  Result := 'Fa�a a seguinte a��o sem adicionar coment�rios:';
  case Self of
    TC4DLanguage.en:
      Result := 'Perform the following action without adding comments:';
    TC4DLanguage.es:
      Result := 'Realice la siguiente acci�n sin agregar comentarios:';
  end;

  Result := Result + sLineBreak;
end;

function TC4DLanguageHelper.GetMsgSQLOnly: string;
begin
  Result := 'Fa�a a seguinte a��o sem adicionar coment�rios e retorne apenas os Comandos SQLs:';
  case Self of
    TC4DLanguage.en:
      Result := 'Perform the following action without adding comments, returning only the SQL commands:';
    TC4DLanguage.es:
      Result := 'Realice la siguiente acci�n sin agregar comentarios, devolviendo solo comandos SQL:';
  end;

  Result := Result + sLineBreak;
end;

function TC4DLanguageHelper.GetMsgJSONIsDatabaseStructure(ASGBDName: string): string;
begin
  Result := 'O seguinte JSON se refere a estrutura SQL de um banco de dados ';
  case Self of
    TC4DLanguage.en:
      Result := 'The following JSON refers to the SQL structure of a database ';
    TC4DLanguage.es:
      Result := 'El siguiente JSON hace referencia a la estructura SQL de una base de datos ';
  end;

  Result := Result + ASGBDName + ' ' + sLineBreak;
end;

function TC4DLanguageHelper.GetMsgJSONInformedAnswerQuestion: string;
begin
  Result := 'Com base nesta estrutura responda a seguinte pergunta e retorne o comando SQL correspondente:';
  case Self of
    TC4DLanguage.en:
      Result := 'Based on the structure that was provided, answer the following question and return the corresponding SQL command:';
    TC4DLanguage.es:
      Result := 'Seg�n la estructura proporcionada, responda la siguiente pregunta y devuelva el comando SQL correspondiente:';
  end;

  Result := Result + sLineBreak;
end;

{ TC4DExtensionsFilesHelper }
function TC4DExtensionsFilesHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TC4DExtensionsFiles), Integer(Self)).ToLower;
end;

function TC4DExtensionsFilesHelper.ToStringWithPoint: string;
begin
  Result := '.' + Self.ToString;
end;

{ TC4DExtensionsOfFilesHelper }
function TC4DExtensionsOfFilesHelper.ContainsStr(const AExtension: string): Boolean;
var
  LExtension: string;
begin
  Result := False;
  LExtension := AExtension.Trim.ToLower;
  if(LExtension = '.pas')then
    Result := TC4DExtensionsFiles.PAS in Self
  else if(LExtension = '.dfm')then
    Result := TC4DExtensionsFiles.DFM in Self
  else if(LExtension = '.fmx')then
    Result := TC4DExtensionsFiles.FMX in Self
  else if(LExtension = '.dpr')then
    Result := TC4DExtensionsFiles.DPR in Self
  else if(LExtension = '.dpk')then
    Result := TC4DExtensionsFiles.DPK in Self
  else if(LExtension = '.dproj')then
    Result := TC4DExtensionsFiles.DPROJ in Self
  else if(LExtension = '.zip')then
    Result := TC4DExtensionsFiles.ZIP in Self
  else if(LExtension = '.bmp')then
    Result := TC4DExtensionsFiles.BMP in Self
  else if(LExtension = '.ini')then
    Result := TC4DExtensionsFiles.INI in Self;
end;

{ TC4DExtensionsCommonHelper }
function TC4DExtensionsCommonHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TC4DExtensionsCommon), Integer(Self)).ToLower;
end;

function TC4DExtensionsCommonHelper.ToStringWithPoint: string;
begin
  Result := '.' + Self.ToString;
end;

{ TC4DQuestionKindHelper }
function TC4DQuestionKindHelper.ToString: string;
begin
  if Self = TC4DQuestionKind.ItemMenuNormal then
    Exit('Item menu normal')
  else if Self = TC4DQuestionKind.MenuMasterOnly then
    Exit('Menu master only')
  else if Self = TC4DQuestionKind.Separators then
    Exit('Separator')
  else
    Result := GetEnumName(TypeInfo(TC4DQuestionKind), Integer(Self));
end;

{ TC4DDriverIDHelper }

function TC4DDriverIDHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TC4DDriverID), Integer(Self));
end;

function TC4DDriverIDHelper.ToStringID: string;
begin
  if Self = TC4DDriverID.Firebird then
    Exit('FB');

  Result := GetEnumName(TypeInfo(TC4DDriverID), Integer(Self));
end;

end.
