/// <summary>
///   Main Class implementation for Face API Microsoft Cognitive Services 1.0
/// </summary>
unit uFaceApi;

interface

uses
  { TStream }
  System.Classes,
  { THTTPClient }
  System.Net.HttpClient,
  { TNetHeaders }
  System.Net.URLClient,
  { TFaceApiServer }
  uFaceApi.Servers.Types,
  { TContentType }
  uFaceApi.Content.Types,
  { TFaceApiBase }
  uFaceApi.Base,
  { IFaceApi }
  uIFaceApi,
  { TDetectOptions }
  uFaceApi.FaceDetectOptions;

type
  /// <summary>
  ///   Main Class implementation for Face API Microsoft Cognitive Services 1.0
  /// </summary>
  TFaceApi = class(TFaceApiBase, IFaceApi)
  private
    function Detect(ARequestType: TContentType; AData: String; AStreamData: TBytesStream; ADetectOptions: TDetectOptions): String;
  public
    function DetectURL(AURL: String; ADetectOptions: TDetectOptions): String;
    function DetectFile(AFileName: String; ADetectOptions: TDetectOptions): String;
    function DetectStream(AStream: TBytesStream; ADetectOptions: TDetectOptions): String;

    /// <summary>
    ///   Implements <see cref="uIFaceApi|IFaceApi.ListPersonGroups">interface ListPersonGroups</see>
    /// </summary>
    function ListPersonGroups(AStart: String = ''; ATop: Integer = 1000): String;

    /// <summary>
    ///   Implements <see cref="uIFaceApi|IFaceApi.ListPersonsInPersonGroup">interface ListPersonsInPersonGroup</see>
    /// </summary>
    function ListPersonsInPersonGroup(APersonGroup: String): String;

    function CreatePerson(AGroupID: String; APersonName: String; APersonUserData: String = ''): String;

    function GetPersonGroupTrainingStatus(AGroupID: String): String;
    function TrainPersonGroup(AGroupID: String): String;

    function CreatePersonGroup(AGroupID: String): String;

    procedure SetAccessKey(const AAccessKey: String; const AAccessServer: TFaceApiServer = fasGeneral);
  end;

implementation

uses
  { Format }
  System.SysUtils,
  { StringHelper }
  uFunctions.StringHelper;

function TFaceApi.CreatePerson(AGroupID, APersonName, APersonUserData: String): String;
var
  LHTTPClient: THTTPClient;
	LStream: TStream;
  LURL: String;
  LHeaders: TNetHeaders;
  LRequestContent: TBytesStream;
begin
  LHTTPClient := PrepareHTTPClient(LHeaders, CONST_CONTENT_TYPE_JSON);

  LURL := Format(
    '%s/persongroups/%s/persons',
    [
      ServerBaseUrl(AccessServer),
      AGroupID
    ]
  );

  LRequestContent := nil;
  try
    LRequestContent := TBytesStream.Create(
      StringHelper.StringToBytesArray(
        Format(
          '{ "name":"%s", "userData":"%s" }',
          [APersonName, APersonUserData]
        )
      )
    );

    LStream := LHTTPClient.Post(LURL, LRequestContent, nil, LHeaders).ContentStream;
  finally
    LRequestContent.Free;
  end;

  Result := ProceedHttpClientData(LHTTPClient, LStream);
end;

function TFaceApi.Detect(ARequestType: TContentType; AData: String; AStreamData: TBytesStream; ADetectOptions: TDetectOptions): String;
var
  LHTTPClient: THTTPClient;
	LStream: TStream;
  LURL: String;
  LHeaders: TNetHeaders;
  LRequestContent: TBytesStream;
begin
  if ARequestType = rtFile then
    if not FileExists(AData) then
      Exit;

  LRequestContent := nil;

  LHTTPClient := PrepareHTTPClient(LHeaders, CONST_CONTENT_TYPE[ARequestType]);
  try
    LURL := Format(
      '%s/detect?returnFaceId=%s&returnFaceLandmarks=%s&returnFaceAttributes=%s',
      [
        ServerBaseUrl(AccessServer),
        BoolToStr(ADetectOptions.FaceId, True).ToLower,
        BoolToStr(ADetectOptions.FaceLandmarks, True).ToLower,
        ADetectOptions.FaceAttributesToString
      ]
    );

    if ARequestType = rtFile then
      LStream := LHTTPClient.Post(LURL, AData, nil, LHeaders).ContentStream
    else
      begin
        if ARequestType = rtStream then
          LRequestContent := TBytesStream.Create(AStreamData.Bytes)
        else
          LRequestContent := TBytesStream.Create(
            StringHelper.StringToBytesArray(
              Format('{ "url":"%s" }', [AData])
            )
          );

        LStream := LHTTPClient.Post(LURL, LRequestContent, nil, LHeaders).ContentStream;
      end;

    Result := ProceedHttpClientData(LHTTPClient, LStream);
  finally
    LRequestContent.Free;
  end;
end;

function TFaceApi.DetectFile(AFileName: String; ADetectOptions: TDetectOptions): String;
begin
  Result := Detect(rtFile, AFileName, nil, ADetectOptions);
end;

function TFaceApi.DetectStream(AStream: TBytesStream; ADetectOptions: TDetectOptions): String;
begin
  Result := Detect(rtStream, '', AStream, ADetectOptions);
end;

function TFaceApi.DetectURL(AURL: String; ADetectOptions: TDetectOptions): String;
begin
  Result := Detect(rtUrl, AURL, nil, ADetectOptions);
end;

function TFaceApi.ListPersonGroups(AStart: String; ATop: Integer): String;
var
  LHTTPClient: THTTPClient;
	LStream: TStream;
  LURL: String;
  LHeaders: TNetHeaders;
begin
  LHTTPClient := PrepareHTTPClient(LHeaders, CONST_CONTENT_TYPE_JSON);

  LURL := Format(
    '%s/persongroups?start=%s&top=%s',
    [
      ServerBaseUrl(AccessServer),
      AStart,
      ATop.ToString
    ]
  );

  LStream := LHTTPClient.Get(LURL, nil, LHeaders).ContentStream;

  Result := ProceedHttpClientData(LHTTPClient, LStream);
end;

function TFaceApi.ListPersonsInPersonGroup(APersonGroup: String): String;
var
  LHTTPClient: THTTPClient;
	LStream: TStream;
  LURL: String;
  LHeaders: TNetHeaders;
begin
  LHTTPClient := PrepareHTTPClient(LHeaders, CONST_CONTENT_TYPE_JSON);

  LURL := Format(
    '%s/persongroups/%s/persons',
    [
      ServerBaseUrl(AccessServer),
      APersonGroup
    ]
  );

  LStream := LHTTPClient.Get(LURL, nil, LHeaders).ContentStream;

  Result := ProceedHttpClientData(LHTTPClient, LStream);
end;

procedure TFaceApi.SetAccessKey(const AAccessKey: String; const AAccessServer: TFaceApiServer);
begin
  AccessKey := AAccessKey;

  AccessServer := AAccessServer;
end;

function TFaceApi.GetPersonGroupTrainingStatus(AGroupID: String): String;
begin
  Result := '';
end;

function TFaceApi.TrainPersonGroup(AGroupID: String): String;
begin
  Result := '';
end;

function TFaceApi.CreatePersonGroup(AGroupID: String): String;
begin
  Result := '';
end;

end.