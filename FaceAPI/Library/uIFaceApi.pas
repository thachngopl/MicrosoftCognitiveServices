/// <summary>
///   Unit contain the Main Interface declaration for Face API Microsoft Cognitive Services 1.0
/// </summary>
unit uIFaceApi;

interface

uses
  { TStringStream }
  System.Classes,
  { TDetectOptions }
  uFaceApi.FaceDetectOptions,
  { TFaceApiServer }
  uFaceApi.Servers.Types,
  { TContentType }
  uFaceApi.Content.Types;

type
  /// <summary>
  ///   Main Interface for Face API Microsoft Cognitive Services 1.0
  /// </summary>
  IFaceApi = interface(IInterface)
    ['{904FC5EC-6ECC-49EB-A3B0-7D785A5D23D2}']

    /// <summary>
    ///   Base function for Detect human faces in an image and returns face locations, and optionally with faceIds, landmarks, and attributes.
    ///   Optional parameters for returning faceId, landmarks, and attributes. Attributes include age, gender, smile intensity, facial hair, head pose and glasses. faceId is for other APIs use including Face - Identify, Face - Verify, and Face - Find Similar. The faceId will expire 24 hours after detection call.
    ///   JPEG, PNG, GIF(the first frame), and BMP are supported. The image file size should be larger than or equal to 1KB but no larger than 4MB.
    ///   The detectable face size is between 36x36 to 4096x4096 pixels. The faces out of this range will not be detected.
    ///   A maximum of 64 faces could be returned for an image. The returned faces are ranked by face rectangle size in descending order.
    ///   Some faces may not be detected for technical challenges, e.g. very large face angles (head-pose) or large occlusion. Frontal and near-frontal faces have the best results.
    ///   Attributes (age, gender, headPose, smile, facialHair, glasses and emotion) are still experimental and may not be very accurate. HeadPose's pitch value is a reserved field and will always return 0.
    /// </summary>
    /// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns an array of face entries ranked by face rectangle size in descending order. An empty response indicates no faces detected.
    ///   A face entry may contain the following values depending on input parameters:
    ///   Fields	        Type	  Description
    ///   faceId	        String	Unique faceId of the detected face, created by detection API and it will expire 24 hours after detection call. To return this, it requires "returnFaceId" parameter to be true.
    ///   faceRectangle	  Object	A rectangle area for the face location on image.
    ///   faceLandmarks	  Object	An array of 27-point face landmarks pointing to the important positions of face components. To return this, it requires "returnFaceLandmarks" parameter to be true.
    ///   faceAttributes	Object 	Face Attributes:
    ///     age: an age number in years.
    ///     gender: male or female.
    ///     smile: smile intensity, a number between [0,1]
    ///     facialHair: consists of lengths of three facial hair areas: moustache, beard and sideburns.
    ///     headPose: 3-D roll/yew/pitch angles for face direction. Pitch value is a reserved field and will always return 0.
    ///     glasses: glasses type. Possible values are 'noGlasses', 'readingGlasses', 'sunglasses', 'swimmingGoggles'.
    ///     emotion: emotions intensity expressed by the face, incluing anger, contempt, disgust, fear, happiness, neutral, sadness and surprise.
    ///
    ///   [ERROR]
    ///   Response 400, 401, 403, 408, 415, 429
    ///   Error code and message returned in JSON:
    ///   Error Code  Error Message Description
    /// </returns>
    function DetectBase(ARequestType: TContentType; AData: String; AStreamData: TBytesStream; ADetectOptions: TDetectOptions): String;

    /// <summary>
    ///   Detect human faces in an image (internet url) and returns face locations, and optionally with faceIds, landmarks, and attributes.
    ///   Wrapper for base <see cref="uIFaceApi|IFaceApi.DetectBase">Detect function</see>
    /// </summary>
		/// <param name="AURL">
    ///   Internet URL of image. You cannot use intranet URL because it will be not accessable by Microsoft Cognitive Services servers.
    /// </param>
		/// <param name="ADetectOptions">
    ///   Face detect options and attributes
    /// </param>
    /// <returns>
    ///   <see cref="uIFaceApi|IFaceApi.DetectBase">See base Detect function</see>
    /// </returns>
    function DetectURL(AURL: String; ADetectOptions: TDetectOptions): String;
    /// <summary>
    ///   Detect human faces in an image (local file name) and returns face locations, and optionally with faceIds, landmarks, and attributes.
    ///   Wrapper for base Detect function
    /// </summary>
		/// <param name="AFileName">
    ///   Local file name with image
    /// </param>
		/// <param name="ADetectOptions">
    ///   Face detect options and attributes
    /// </param>
    /// <returns>
    ///   <see cref="uIFaceApi|IFaceApi.DetectBase">See base Detect function</see>
    /// </returns>
    function DetectFile(AFileName: String; ADetectOptions: TDetectOptions): String;
    /// <summary>
    ///   Detect human faces in an image (stream) and returns face locations, and optionally with faceIds, landmarks, and attributes.
    ///   Wrapper for base Detect function
    /// </summary>
		/// <param name="AStream">
    ///   Stream with image
    /// </param>
		/// <param name="ADetectOptions">
    ///   Face detect options and attributes
    /// </param>
    /// <returns>
    ///   <see cref="uIFaceApi|IFaceApi.DetectBase">See base Detect function</see>
    /// </returns>
    function DetectStream(AStream: TBytesStream; ADetectOptions: TDetectOptions): String;

    /// <summary>
    ///   List person groups and their information.
    /// </summary>
		/// <param name="AStart">
		///   (optional)
    ///   List person groups from the least personGroupId greater than the "start". It contains no more than 64 characters. Default is empty.
		/// </param>
		/// <param name="ATop">
		///   (optional)
    ///   The number of person groups to list, ranging in [1, 1000]. Default is 1000.
		/// </param>
		/// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns an array of person groups and their information (personGroupId, name and userData).
    ///   JSON fields in response body:
    ///   Fields	Type	Description
    ///   personGroupId	  String	  personGroupId of the existing person groups, created in Person Group - Create a Person Group.
    ///   name	          String	  Person group's display name.
    ///   userData	      String	  User-provided data attached to this person group.
    ///
    ///   [ERROR]
    ///   Response 400, 401, 403, 409, 429
    ///   Error code and message returned in JSON:
    ///   Error Code  Error Message Description
    /// </returns>
    function ListPersonGroups(AStart: String = ''; ATop: Integer = 1000): String;

    /// <summary>
    ///   List all persons in a person group, and retrieve person information (including personId, name, userData and persistedFaceIds of registered faces of the person).
    /// </summary>
		/// <param name="AGroupID">
    ///   Id of the target person group.
		/// </param>
    /// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns an array of person information that belong to the person group.
    ///   JSON fields in response body:
    ///   Fields	          Type	Description
    ///   personId	        String	personId of the person in the person group.
    ///   name	            String	Person's display name.
    ///   userData	        String	User-provided data attached to the person.
    ///   persistedFaceIds  Array	  persistedFaceId array of registered faces of the person.
    ///
    ///   [ERROR]
    ///   Response 401, 403, 404, 409, 415, 429
    ///   Error code and message returned in JSON:
    ///   Error Code	Error Message Description
    /// </returns>
    function ListPersonsInPersonGroup(AGroupID: String): String;

    /// <summary>
    ///   Create a new person in a specified person group. A newly created person have no registered face.
    ///   The number of persons has a subscription level limit and person group level limit. Person group level limit is 1000 for both free and paid tier subscriptions.
    ///   Subscription level limit is 1000 for free tier subscription and can be greater in paid tier subscriptions.
    /// </summary>
		/// <param name="AGroupID">
    ///   Target person group to be trained.
		/// </param>
		/// <param name="APersonName">
    ///   Display name of the target person. The maximum length is 128.
		/// </param>
		/// <param name="APersonUserData">
    ///   (optional)
    ///   Optional fields for user-provided data attached to a person. Size limit is 16KB.
		/// </param>
    /// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns a new personId created.
    ///   JSON fields in response body:
    ///   Fields	  Type	  Description
    ///   personId	String	personID of the new created person.
    ///
    ///   [ERROR]
    ///   Response 400, 401, 403, 404, 409, 415, 429
    ///   Error code and message returned in JSON:
    ///   Error Code	Error Message Description
    /// </returns>
    function CreatePerson(AGroupID: String; APersonName: String; APersonUserData: String = ''): String;

    /// <summary>
    ///   Retrieve the training status of a person group (completed or ongoing).
    ///   The training will process for a while on the server side.
    /// </summary>
		/// <param name="AGroupID">
    ///   String
    ///   Id of target person group.
		/// </param>
    /// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns the person group's training status.
    ///   JSON fields in response body:
    ///   Fields	            Type	  Description
    ///   status	            String	Training status: notstarted, running, succeeded, failed. If the training process is waiting to perform, the status is notstarted. If the training is ongoing, the status is running. Status succeed means this person group is ready for Face - Identify. Status failed is often caused by no person or no persisted face exist in the person group.
    ///   createdDateTime	    String	A combined UTC date and time string that describes person group created time, delimited by the letter T. E.g. 1/3/2017 4:11:35 AM.
    ///   lastActionDateTime	String	Person group last modify time in the UTC, could be null value when the person group is not successfully trained.
    ///   message	            String	Show failure message when training failed (omitted when training succeed).
    ///
    ///   [ERROR]
    ///   Response 401, 403, 404, 409, 429
    ///   Error code and message returned in JSON:
    ///   Error Code	Error Message Description
    /// </returns>
    function GetPersonGroupTrainingStatus(AGroupID: String): String;
    /// <summary>
    ///   Queue a person group training task, the training task may not be started immediately.
    ///   Any updates to person group will not take effect in Face - Identify until person group is successfully trained.
    /// </summary>
		/// <param name="AGroupID">
    ///   String
    ///   Id of the Target person group to be trained.
		/// </param>
    /// <returns>
    ///   [OK]
    ///   Response 202
    ///   A successful call returns an empty JSON body.
    ///
    ///   [ERROR]
    ///   Response 401, 403, 404, 409, 429
    ///   Error code and message returned in JSON:
    ///   Error Code	Error Message Description
    /// </returns>
    function TrainPersonGroup(AGroupID: String): String;

    /// <summary>
    ///   Create a new person group with specified personGroupId, name and user-provided userData.
    ///   A person group is one of the most important parameters for the Face - Identify API.
    /// </summary>
		/// <param name="AGroupID">
    ///   User-provided personGroupId as a string. The valid characters include numbers, English letters in lower case, '-' and '_'. The maximum length of the personGroupId is 64.
		/// </param>
    /// <returns>
    ///   [OK]
    ///   Response 200
    ///   A successful call returns an empty response body.
    ///
    ///   [ERROR]
    ///   Response 400, 401, 403, 409, 415, 429
    ///   Error code and message returned in JSON:
    ///   Error Code	Error Message Description
    /// </returns>
    function CreatePersonGroup(AGroupID: String): String;

    /// <summary>
    ///   Verify whether two faces belong to a same person
    ///   Remarks:
    ///     This API works well for frontal and near-frontal faces.
    ///     For the scenarios that are sensitive to accuracy please make your own judgment.
    /// </summary>
		/// <param name="AFaceTempID1">
    ///     Temp Face Id of one face, comes from Face - Detect.
		/// </param>
		/// <param name="AFaceTempID2">
    ///     Temp Cace Id of another face, comes from Face - Detect.
		/// </param>
    function Verify(AFaceTempID1, AFaceTempID2: String): String; overload;
    /// <summary>
    ///   Verify whether one face belongs to a person
    /// </summary>
		/// <param name="AFaceTempID">
    ///     Temp Face Id of one face, comes from Face - Detect.
		/// </param>
		/// <param name="APersonID">
    ///   Specify a certain person in a person group. personId is created in <see cref="uIFaceApi|IFaceApi.CreatePerson">Person - Create a Person</see>.
    /// </param>
		/// <param name="AGroupID">
    ///   Using existing personGroupId
		/// </param>
    function Verify(AFaceTempID, APersonID, AGroupID: String): String; overload;

    procedure SetAccessKey(const AAccessKey: String; const AAccessServer: TFaceApiServer = fasGeneral);
  end;

implementation

end.