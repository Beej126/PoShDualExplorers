#if (!(Test-Path $PSScriptRoot\FontAwesome.dll)) {
Add-Type <#-OutputAssembly $PSScriptRoot\FontAwesome.dll#> -ReferencedAssemblies @("System.Drawing", "System.Windows.Forms") -TypeDefinition @"
//from here: https://github.com/microvb/FontAwesome-For-WinForms-CSharp

using System.Drawing;
using System.Drawing.Text;
using System;
using System.Windows.Forms;
using System.Collections.Generic;

public sealed class FaButton : Panel
{
  public Button ThisButton { get; private set; }

  public string FaType { get { return ThisButton.Text; } set { ThisButton.Text = value; } }

  public FaButton(int width, int labelHeight, string toolTipText, string caption, float faSize, string faType, Control parent)
  {
    Dock = DockStyle.Left;
    Width = width;
    //BorderStyle = BorderStyle.FixedSingle;

    ThisButton = new Button
    {
      Dock = DockStyle.Top,
      Height = (int)faSize + 13,
      Text = faType,
      Font = Fa.Get(faSize),
      TextAlign = ContentAlignment.BottomCenter
    };

    var toolTip = new ToolTip();
    toolTip.SetToolTip(ThisButton, toolTipText);
    Controls.Add(ThisButton);

    /*
    var label = new Label
    {
      Text = caption,
      TextAlign = ContentAlignment.MiddleCenter,
      Dock = DockStyle.Top,
      Height = labelHeight
    };
    Controls.Add(label);
    */

    parent.Controls.Add(this);

    parent.Height = ThisButton.Height;// + label.Height;
  }

}

public static class Fa
{
  public static string CurrentExecutionPath
  {
    get { return System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location); }
  }

  //nugget: huge tough find! had endless crashes before i read something about being careful not to dispose PrivateFontCollection too early
  //prior to this arrangement i was creating a new PrivateFontCollection per each font size instantiation... no blowups in Windows Forms but same exact code was VERY explosive under PowerShell execution context
  private static PrivateFontCollection _fontCollection ;
  public static string TtfFilePath
  {
    set
    {
      _fontCollection = new PrivateFontCollection();
      _fontCollection.AddFontFile(value);
    }
  }

  // ReSharper disable once InconsistentNaming
  static private readonly Dictionary<float, Font> _fontCache = new Dictionary<float, Font>();
  static public Font Get(float pixelSize)
  {
    if (_fontCollection == null)
      throw new Exception(@"** must set [Fa]::TtfFilePath ** e.g. c:\users\me\project\fontawesome-webfont.ttf");

    Font font;
    if (_fontCache.TryGetValue(pixelSize, out font)) return font;

    font = new Font(_fontCollection.Families[0], pixelSize, FontStyle.Regular, GraphicsUnit.Pixel);
    _fontCache.Add(pixelSize, font);

    return font;
  }


  private static string UnicodeToChar(string hex)
  {
    var code = int.Parse(hex, System.Globalization.NumberStyles.HexNumber);
    var unicodeString = char.ConvertFromUtf32(code);
    return unicodeString;
  }
  public static string Glass { get { return UnicodeToChar("f000"); } }
  public static string Music { get { return UnicodeToChar("f001"); } }
  public static string Search { get { return UnicodeToChar("f002"); } }
  public static string EnvelopeO { get { return UnicodeToChar("f003"); } }
  public static string Heart { get { return UnicodeToChar("f004"); } }
  public static string Star { get { return UnicodeToChar("f005"); } }
  public static string StarO { get { return UnicodeToChar("f006"); } }
  public static string User { get { return UnicodeToChar("f007"); } }
  public static string Film { get { return UnicodeToChar("f008"); } }
  public static string ThLarge { get { return UnicodeToChar("f009"); } }
  public static string Th { get { return UnicodeToChar("f00a"); } }
  public static string ThList { get { return UnicodeToChar("f00b"); } }
  public static string Check { get { return UnicodeToChar("f00c"); } }
  public static string Remove { get { return UnicodeToChar("f00d"); } }
  public static string Close { get { return UnicodeToChar("f00d"); } }
  public static string Times { get { return UnicodeToChar("f00d"); } }
  public static string SearchPlus { get { return UnicodeToChar("f00e"); } }
  public static string SearchMinus { get { return UnicodeToChar("f010"); } }
  public static string PowerOff { get { return UnicodeToChar("f011"); } }
  public static string Signal { get { return UnicodeToChar("f012"); } }
  public static string Gear { get { return UnicodeToChar("f013"); } }
  public static string Cog { get { return UnicodeToChar("f013"); } }
  public static string TrashO { get { return UnicodeToChar("f014"); } }
  public static string Home { get { return UnicodeToChar("f015"); } }
  public static string FileO { get { return UnicodeToChar("f016"); } }
  public static string ClockO { get { return UnicodeToChar("f017"); } }
  public static string Road { get { return UnicodeToChar("f018"); } }
  public static string Download { get { return UnicodeToChar("f019"); } }
  public static string ArrowCircleODown { get { return UnicodeToChar("f01a"); } }
  public static string ArrowCircleOUp { get { return UnicodeToChar("f01b"); } }
  public static string Inbox { get { return UnicodeToChar("f01c"); } }
  public static string PlayCircleO { get { return UnicodeToChar("f01d"); } }
  public static string RotateRight { get { return UnicodeToChar("f01e"); } }
  public static string Repeat { get { return UnicodeToChar("f01e"); } }
  public static string Refresh { get { return UnicodeToChar("f021"); } }
  public static string ListAlt { get { return UnicodeToChar("f022"); } }
  public static string Lock { get { return UnicodeToChar("f023"); } }
  public static string Flag { get { return UnicodeToChar("f024"); } }
  public static string Headphones { get { return UnicodeToChar("f025"); } }
  public static string VolumeOff { get { return UnicodeToChar("f026"); } }
  public static string VolumeDown { get { return UnicodeToChar("f027"); } }
  public static string VolumeUp { get { return UnicodeToChar("f028"); } }
  public static string Qrcode { get { return UnicodeToChar("f029"); } }
  public static string Barcode { get { return UnicodeToChar("f02a"); } }
  public static string Tag { get { return UnicodeToChar("f02b"); } }
  public static string Tags { get { return UnicodeToChar("f02c"); } }
  public static string Book { get { return UnicodeToChar("f02d"); } }
  public static string Bookmark { get { return UnicodeToChar("f02e"); } }
  public static string Print { get { return UnicodeToChar("f02f"); } }
  public static string Camera { get { return UnicodeToChar("f030"); } }
  // ReSharper disable once InconsistentNaming
  public static string Font_ { get { return UnicodeToChar("f031"); } }
  public static string Bold { get { return UnicodeToChar("f032"); } }
  public static string Italic { get { return UnicodeToChar("f033"); } }
  public static string TextHeight { get { return UnicodeToChar("f034"); } }
  public static string TextWidth { get { return UnicodeToChar("f035"); } }
  public static string AlignLeft { get { return UnicodeToChar("f036"); } }
  public static string AlignCenter { get { return UnicodeToChar("f037"); } }
  public static string AlignRight { get { return UnicodeToChar("f038"); } }
  public static string AlignJustify { get { return UnicodeToChar("f039"); } }
  public static string List { get { return UnicodeToChar("f03a"); } }
  public static string Dedent { get { return UnicodeToChar("f03b"); } }
  public static string Outdent { get { return UnicodeToChar("f03b"); } }
  public static string Indent { get { return UnicodeToChar("f03c"); } }
  public static string VideoCamera { get { return UnicodeToChar("f03d"); } }
  public static string Photo { get { return UnicodeToChar("f03e"); } }
  public static string Image { get { return UnicodeToChar("f03e"); } }
  public static string PictureO { get { return UnicodeToChar("f03e"); } }
  public static string Pencil { get { return UnicodeToChar("f040"); } }
  public static string MapMarker { get { return UnicodeToChar("f041"); } }
  public static string Adjust { get { return UnicodeToChar("f042"); } }
  public static string Tint { get { return UnicodeToChar("f043"); } }
  public static string Edit { get { return UnicodeToChar("f044"); } }
  public static string PencilSquareO { get { return UnicodeToChar("f044"); } }
  public static string ShareSquareO { get { return UnicodeToChar("f045"); } }
  public static string CheckSquareO { get { return UnicodeToChar("f046"); } }
  public static string Arrows { get { return UnicodeToChar("f047"); } }
  public static string StepBackward { get { return UnicodeToChar("f048"); } }
  public static string FastBackward { get { return UnicodeToChar("f049"); } }
  public static string Backward { get { return UnicodeToChar("f04a"); } }
  public static string Play { get { return UnicodeToChar("f04b"); } }
  public static string Pause { get { return UnicodeToChar("f04c"); } }
  public static string Stop { get { return UnicodeToChar("f04d"); } }
  public static string Forward { get { return UnicodeToChar("f04e"); } }
  public static string FastForward { get { return UnicodeToChar("f050"); } }
  public static string StepForward { get { return UnicodeToChar("f051"); } }
  public static string Eject { get { return UnicodeToChar("f052"); } }
  public static string ChevronLeft { get { return UnicodeToChar("f053"); } }
  public static string ChevronRight { get { return UnicodeToChar("f054"); } }
  public static string PlusCircle { get { return UnicodeToChar("f055"); } }
  public static string MinusCircle { get { return UnicodeToChar("f056"); } }
  public static string TimesCircle { get { return UnicodeToChar("f057"); } }
  public static string CheckCircle { get { return UnicodeToChar("f058"); } }
  public static string QuestionCircle { get { return UnicodeToChar("f059"); } }
  public static string InfoCircle { get { return UnicodeToChar("f05a"); } }
  public static string Crosshairs { get { return UnicodeToChar("f05b"); } }
  public static string TimesCircleO { get { return UnicodeToChar("f05c"); } }
  public static string CheckCircleO { get { return UnicodeToChar("f05d"); } }
  public static string Ban { get { return UnicodeToChar("f05e"); } }
  public static string ArrowLeft { get { return UnicodeToChar("f060"); } }
  public static string ArrowRight { get { return UnicodeToChar("f061"); } }
  public static string ArrowUp { get { return UnicodeToChar("f062"); } }
  public static string ArrowDown { get { return UnicodeToChar("f063"); } }
  public static string MailForward { get { return UnicodeToChar("f064"); } }
  public static string Share { get { return UnicodeToChar("f064"); } }
  public static string Expand { get { return UnicodeToChar("f065"); } }
  public static string Compress { get { return UnicodeToChar("f066"); } }
  public static string Plus { get { return UnicodeToChar("f067"); } }
  public static string Minus { get { return UnicodeToChar("f068"); } }
  public static string Asterisk { get { return UnicodeToChar("f069"); } }
  public static string ExclamationCircle { get { return UnicodeToChar("f06a"); } }
  public static string Gift { get { return UnicodeToChar("f06b"); } }
  public static string Leaf { get { return UnicodeToChar("f06c"); } }
  public static string Fire { get { return UnicodeToChar("f06d"); } }
  public static string Eye { get { return UnicodeToChar("f06e"); } }
  public static string EyeSlash { get { return UnicodeToChar("f070"); } }
  public static string Warning { get { return UnicodeToChar("f071"); } }
  public static string ExclamationTriangle { get { return UnicodeToChar("f071"); } }
  public static string Plane { get { return UnicodeToChar("f072"); } }
  public static string Calendar { get { return UnicodeToChar("f073"); } }
  public static string Random { get { return UnicodeToChar("f074"); } }
  public static string Comment { get { return UnicodeToChar("f075"); } }
  public static string Magnet { get { return UnicodeToChar("f076"); } }
  public static string ChevronUp { get { return UnicodeToChar("f077"); } }
  public static string ChevronDown { get { return UnicodeToChar("f078"); } }
  public static string Retweet { get { return UnicodeToChar("f079"); } }
  public static string ShoppingCart { get { return UnicodeToChar("f07a"); } }
  public static string Folder { get { return UnicodeToChar("f07b"); } }
  public static string FolderOpen { get { return UnicodeToChar("f07c"); } }
  public static string ArrowsV { get { return UnicodeToChar("f07d"); } }
  public static string ArrowsH { get { return UnicodeToChar("f07e"); } }
  public static string BarChartO { get { return UnicodeToChar("f080"); } }
  public static string BarChart { get { return UnicodeToChar("f080"); } }
  public static string TwitterSquare { get { return UnicodeToChar("f081"); } }
  public static string FacebookSquare { get { return UnicodeToChar("f082"); } }
  public static string CameraRetro { get { return UnicodeToChar("f083"); } }
  public static string Key { get { return UnicodeToChar("f084"); } }
  public static string Gears { get { return UnicodeToChar("f085"); } }
  public static string Cogs { get { return UnicodeToChar("f085"); } }
  public static string Comments { get { return UnicodeToChar("f086"); } }
  public static string ThumbsOUp { get { return UnicodeToChar("f087"); } }
  public static string ThumbsODown { get { return UnicodeToChar("f088"); } }
  public static string StarHalf { get { return UnicodeToChar("f089"); } }
  public static string HeartO { get { return UnicodeToChar("f08a"); } }
  public static string SignOut { get { return UnicodeToChar("f08b"); } }
  public static string LinkedinSquare { get { return UnicodeToChar("f08c"); } }
  public static string ThumbTack { get { return UnicodeToChar("f08d"); } }
  public static string ExternalLink { get { return UnicodeToChar("f08e"); } }
  public static string SignIn { get { return UnicodeToChar("f090"); } }
  public static string Trophy { get { return UnicodeToChar("f091"); } }
  public static string GithubSquare { get { return UnicodeToChar("f092"); } }
  public static string Upload { get { return UnicodeToChar("f093"); } }
  public static string LemonO { get { return UnicodeToChar("f094"); } }
  public static string Phone { get { return UnicodeToChar("f095"); } }
  public static string SquareO { get { return UnicodeToChar("f096"); } }
  public static string BookmarkO { get { return UnicodeToChar("f097"); } }
  public static string PhoneSquare { get { return UnicodeToChar("f098"); } }
  public static string Twitter { get { return UnicodeToChar("f099"); } }
  public static string FacebookF { get { return UnicodeToChar("f09a"); } }
  public static string Facebook { get { return UnicodeToChar("f09a"); } }
  public static string Github { get { return UnicodeToChar("f09b"); } }
  public static string Unlock { get { return UnicodeToChar("f09c"); } }
  public static string CreditCard { get { return UnicodeToChar("f09d"); } }
  public static string Feed { get { return UnicodeToChar("f09e"); } }
  public static string Rss { get { return UnicodeToChar("f09e"); } }
  public static string HddO { get { return UnicodeToChar("f0a0"); } }
  public static string Bullhorn { get { return UnicodeToChar("f0a1"); } }
  public static string Bell { get { return UnicodeToChar("f0f3"); } }
  public static string Certificate { get { return UnicodeToChar("f0a3"); } }
  public static string HandORight { get { return UnicodeToChar("f0a4"); } }
  public static string HandOLeft { get { return UnicodeToChar("f0a5"); } }
  public static string HandOUp { get { return UnicodeToChar("f0a6"); } }
  public static string HandODown { get { return UnicodeToChar("f0a7"); } }
  public static string ArrowCircleLeft { get { return UnicodeToChar("f0a8"); } }
  public static string ArrowCircleRight { get { return UnicodeToChar("f0a9"); } }
  public static string ArrowCircleUp { get { return UnicodeToChar("f0aa"); } }
  public static string ArrowCircleDown { get { return UnicodeToChar("f0ab"); } }
  public static string Globe { get { return UnicodeToChar("f0ac"); } }
  public static string Wrench { get { return UnicodeToChar("f0ad"); } }
  public static string Tasks { get { return UnicodeToChar("f0ae"); } }
  public static string Filter { get { return UnicodeToChar("f0b0"); } }
  public static string Briefcase { get { return UnicodeToChar("f0b1"); } }
  public static string ArrowsAlt { get { return UnicodeToChar("f0b2"); } }
  public static string Group { get { return UnicodeToChar("f0c0"); } }
  public static string Users { get { return UnicodeToChar("f0c0"); } }
  public static string Chain { get { return UnicodeToChar("f0c1"); } }
  public static string Link { get { return UnicodeToChar("f0c1"); } }
  public static string Cloud { get { return UnicodeToChar("f0c2"); } }
  public static string Flask { get { return UnicodeToChar("f0c3"); } }
  public static string Cut { get { return UnicodeToChar("f0c4"); } }
  public static string Scissors { get { return UnicodeToChar("f0c4"); } }
  public static string Copy { get { return UnicodeToChar("f0c5"); } }
  public static string FilesO { get { return UnicodeToChar("f0c5"); } }
  public static string Paperclip { get { return UnicodeToChar("f0c6"); } }
  public static string Save { get { return UnicodeToChar("f0c7"); } }
  public static string FloppyO { get { return UnicodeToChar("f0c7"); } }
  public static string Square { get { return UnicodeToChar("f0c8"); } }
  public static string Navicon { get { return UnicodeToChar("f0c9"); } }
  public static string Reorder { get { return UnicodeToChar("f0c9"); } }
  public static string Bars { get { return UnicodeToChar("f0c9"); } }
  public static string ListUl { get { return UnicodeToChar("f0ca"); } }
  public static string ListOl { get { return UnicodeToChar("f0cb"); } }
  public static string Strikethrough { get { return UnicodeToChar("f0cc"); } }
  public static string Underline { get { return UnicodeToChar("f0cd"); } }
  public static string Table { get { return UnicodeToChar("f0ce"); } }
  public static string Magic { get { return UnicodeToChar("f0d0"); } }
  public static string Truck { get { return UnicodeToChar("f0d1"); } }
  public static string Pinterest { get { return UnicodeToChar("f0d2"); } }
  public static string PinterestSquare { get { return UnicodeToChar("f0d3"); } }
  public static string GooglePlusSquare { get { return UnicodeToChar("f0d4"); } }
  public static string GooglePlus { get { return UnicodeToChar("f0d5"); } }
  public static string Money { get { return UnicodeToChar("f0d6"); } }
  public static string CaretDown { get { return UnicodeToChar("f0d7"); } }
  public static string CaretUp { get { return UnicodeToChar("f0d8"); } }
  public static string CaretLeft { get { return UnicodeToChar("f0d9"); } }
  public static string CaretRight { get { return UnicodeToChar("f0da"); } }
  public static string Columns { get { return UnicodeToChar("f0db"); } }
  public static string Unsorted { get { return UnicodeToChar("f0dc"); } }
  public static string Sort { get { return UnicodeToChar("f0dc"); } }
  public static string SortDown { get { return UnicodeToChar("f0dd"); } }
  public static string SortDesc { get { return UnicodeToChar("f0dd"); } }
  public static string SortUp { get { return UnicodeToChar("f0de"); } }
  public static string SortAsc { get { return UnicodeToChar("f0de"); } }
  public static string Envelope { get { return UnicodeToChar("f0e0"); } }
  public static string Linkedin { get { return UnicodeToChar("f0e1"); } }
  public static string RotateLeft { get { return UnicodeToChar("f0e2"); } }
  public static string Undo { get { return UnicodeToChar("f0e2"); } }
  public static string Legal { get { return UnicodeToChar("f0e3"); } }
  public static string Gavel { get { return UnicodeToChar("f0e3"); } }
  public static string Dashboard { get { return UnicodeToChar("f0e4"); } }
  public static string Tachometer { get { return UnicodeToChar("f0e4"); } }
  public static string CommentO { get { return UnicodeToChar("f0e5"); } }
  public static string CommentsO { get { return UnicodeToChar("f0e6"); } }
  public static string Flash { get { return UnicodeToChar("f0e7"); } }
  public static string Bolt { get { return UnicodeToChar("f0e7"); } }
  public static string Sitemap { get { return UnicodeToChar("f0e8"); } }
  public static string Umbrella { get { return UnicodeToChar("f0e9"); } }
  public static string Paste { get { return UnicodeToChar("f0ea"); } }
  public static string Clipboard { get { return UnicodeToChar("f0ea"); } }
  public static string LightbulbO { get { return UnicodeToChar("f0eb"); } }
  public static string Exchange { get { return UnicodeToChar("f0ec"); } }
  public static string CloudDownload { get { return UnicodeToChar("f0ed"); } }
  public static string CloudUpload { get { return UnicodeToChar("f0ee"); } }
  public static string UserMd { get { return UnicodeToChar("f0f0"); } }
  public static string Stethoscope { get { return UnicodeToChar("f0f1"); } }
  public static string Suitcase { get { return UnicodeToChar("f0f2"); } }
  public static string BellO { get { return UnicodeToChar("f0a2"); } }
  public static string Coffee { get { return UnicodeToChar("f0f4"); } }
  public static string Cutlery { get { return UnicodeToChar("f0f5"); } }
  public static string FileTextO { get { return UnicodeToChar("f0f6"); } }
  public static string BuildingO { get { return UnicodeToChar("f0f7"); } }
  public static string HospitalO { get { return UnicodeToChar("f0f8"); } }
  public static string Ambulance { get { return UnicodeToChar("f0f9"); } }
  public static string Medkit { get { return UnicodeToChar("f0fa"); } }
  public static string FighterJet { get { return UnicodeToChar("f0fb"); } }
  public static string Beer { get { return UnicodeToChar("f0fc"); } }
  public static string HSquare { get { return UnicodeToChar("f0fd"); } }
  public static string PlusSquare { get { return UnicodeToChar("f0fe"); } }
  public static string AngleDoubleLeft { get { return UnicodeToChar("f100"); } }
  public static string AngleDoubleRight { get { return UnicodeToChar("f101"); } }
  public static string AngleDoubleUp { get { return UnicodeToChar("f102"); } }
  public static string AngleDoubleDown { get { return UnicodeToChar("f103"); } }
  public static string AngleLeft { get { return UnicodeToChar("f104"); } }
  public static string AngleRight { get { return UnicodeToChar("f105"); } }
  public static string AngleUp { get { return UnicodeToChar("f106"); } }
  public static string AngleDown { get { return UnicodeToChar("f107"); } }
  public static string Desktop { get { return UnicodeToChar("f108"); } }
  public static string Laptop { get { return UnicodeToChar("f109"); } }
  public static string Tablet { get { return UnicodeToChar("f10a"); } }
  public static string MobilePhone { get { return UnicodeToChar("f10b"); } }
  public static string Mobile { get { return UnicodeToChar("f10b"); } }
  public static string CircleO { get { return UnicodeToChar("f10c"); } }
  public static string QuoteLeft { get { return UnicodeToChar("f10d"); } }
  public static string QuoteRight { get { return UnicodeToChar("f10e"); } }
  public static string Spinner { get { return UnicodeToChar("f110"); } }
  public static string Circle { get { return UnicodeToChar("f111"); } }
  public static string MailReply { get { return UnicodeToChar("f112"); } }
  public static string Reply { get { return UnicodeToChar("f112"); } }
  public static string GithubAlt { get { return UnicodeToChar("f113"); } }
  public static string FolderO { get { return UnicodeToChar("f114"); } }
  public static string FolderOpenO { get { return UnicodeToChar("f115"); } }
  public static string SmileO { get { return UnicodeToChar("f118"); } }
  public static string FrownO { get { return UnicodeToChar("f119"); } }
  public static string MehO { get { return UnicodeToChar("f11a"); } }
  public static string Gamepad { get { return UnicodeToChar("f11b"); } }
  public static string KeyboardO { get { return UnicodeToChar("f11c"); } }
  public static string FlagO { get { return UnicodeToChar("f11d"); } }
  public static string FlagCheckered { get { return UnicodeToChar("f11e"); } }
  public static string Terminal { get { return UnicodeToChar("f120"); } }
  public static string Code { get { return UnicodeToChar("f121"); } }
  public static string MailReplyAll { get { return UnicodeToChar("f122"); } }
  public static string ReplyAll { get { return UnicodeToChar("f122"); } }
  public static string StarHalfEmpty { get { return UnicodeToChar("f123"); } }
  public static string StarHalfFull { get { return UnicodeToChar("f123"); } }
  public static string StarHalfO { get { return UnicodeToChar("f123"); } }
  public static string LocationArrow { get { return UnicodeToChar("f124"); } }
  public static string Crop { get { return UnicodeToChar("f125"); } }
  public static string CodeFork { get { return UnicodeToChar("f126"); } }
  public static string Unlink { get { return UnicodeToChar("f127"); } }
  public static string ChainBroken { get { return UnicodeToChar("f127"); } }
  public static string Question { get { return UnicodeToChar("f128"); } }
  public static string Info { get { return UnicodeToChar("f129"); } }
  public static string Exclamation { get { return UnicodeToChar("f12a"); } }
  public static string Superscript { get { return UnicodeToChar("f12b"); } }
  public static string Subscript { get { return UnicodeToChar("f12c"); } }
  public static string Eraser { get { return UnicodeToChar("f12d"); } }
  public static string PuzzlePiece { get { return UnicodeToChar("f12e"); } }
  public static string Microphone { get { return UnicodeToChar("f130"); } }
  public static string MicrophoneSlash { get { return UnicodeToChar("f131"); } }
  public static string Shield { get { return UnicodeToChar("f132"); } }
  public static string CalendarO { get { return UnicodeToChar("f133"); } }
  public static string FireExtinguisher { get { return UnicodeToChar("f134"); } }
  public static string Rocket { get { return UnicodeToChar("f135"); } }
  public static string Maxcdn { get { return UnicodeToChar("f136"); } }
  public static string ChevronCircleLeft { get { return UnicodeToChar("f137"); } }
  public static string ChevronCircleRight { get { return UnicodeToChar("f138"); } }
  public static string ChevronCircleUp { get { return UnicodeToChar("f139"); } }
  public static string ChevronCircleDown { get { return UnicodeToChar("f13a"); } }
  public static string Html5 { get { return UnicodeToChar("f13b"); } }
  public static string Css3 { get { return UnicodeToChar("f13c"); } }
  public static string Anchor { get { return UnicodeToChar("f13d"); } }
  public static string UnlockAlt { get { return UnicodeToChar("f13e"); } }
  public static string Bullseye { get { return UnicodeToChar("f140"); } }
  public static string EllipsisH { get { return UnicodeToChar("f141"); } }
  public static string EllipsisV { get { return UnicodeToChar("f142"); } }
  public static string RssSquare { get { return UnicodeToChar("f143"); } }
  public static string PlayCircle { get { return UnicodeToChar("f144"); } }
  public static string Ticket { get { return UnicodeToChar("f145"); } }
  public static string MinusSquare { get { return UnicodeToChar("f146"); } }
  public static string MinusSquareO { get { return UnicodeToChar("f147"); } }
  public static string LevelUp { get { return UnicodeToChar("f148"); } }
  public static string LevelDown { get { return UnicodeToChar("f149"); } }
  public static string CheckSquare { get { return UnicodeToChar("f14a"); } }
  public static string PencilSquare { get { return UnicodeToChar("f14b"); } }
  public static string ExternalLinkSquare { get { return UnicodeToChar("f14c"); } }
  public static string ShareSquare { get { return UnicodeToChar("f14d"); } }
  public static string Compass { get { return UnicodeToChar("f14e"); } }
  public static string ToggleDown { get { return UnicodeToChar("f150"); } }
  public static string CaretSquareODown { get { return UnicodeToChar("f150"); } }
  public static string ToggleUp { get { return UnicodeToChar("f151"); } }
  public static string CaretSquareOUp { get { return UnicodeToChar("f151"); } }
  public static string ToggleRight { get { return UnicodeToChar("f152"); } }
  public static string CaretSquareORight { get { return UnicodeToChar("f152"); } }
  public static string Euro { get { return UnicodeToChar("f153"); } }
  public static string Eur { get { return UnicodeToChar("f153"); } }
  public static string Gbp { get { return UnicodeToChar("f154"); } }
  public static string Dollar { get { return UnicodeToChar("f155"); } }
  public static string Usd { get { return UnicodeToChar("f155"); } }
  public static string Rupee { get { return UnicodeToChar("f156"); } }
  public static string Inr { get { return UnicodeToChar("f156"); } }
  public static string Cny { get { return UnicodeToChar("f157"); } }
  public static string Rmb { get { return UnicodeToChar("f157"); } }
  public static string Yen { get { return UnicodeToChar("f157"); } }
  public static string Jpy { get { return UnicodeToChar("f157"); } }
  public static string Ruble { get { return UnicodeToChar("f158"); } }
  public static string Rouble { get { return UnicodeToChar("f158"); } }
  public static string Rub { get { return UnicodeToChar("f158"); } }
  public static string Won { get { return UnicodeToChar("f159"); } }
  public static string Krw { get { return UnicodeToChar("f159"); } }
  public static string Bitcoin { get { return UnicodeToChar("f15a"); } }
  public static string Btc { get { return UnicodeToChar("f15a"); } }
  public static string File { get { return UnicodeToChar("f15b"); } }
  public static string FileText { get { return UnicodeToChar("f15c"); } }
  public static string SortAlphaAsc { get { return UnicodeToChar("f15d"); } }
  public static string SortAlphaDesc { get { return UnicodeToChar("f15e"); } }
  public static string SortAmountAsc { get { return UnicodeToChar("f160"); } }
  public static string SortAmountDesc { get { return UnicodeToChar("f161"); } }
  public static string SortNumericAsc { get { return UnicodeToChar("f162"); } }
  public static string SortNumericDesc { get { return UnicodeToChar("f163"); } }
  public static string ThumbsUp { get { return UnicodeToChar("f164"); } }
  public static string ThumbsDown { get { return UnicodeToChar("f165"); } }
  public static string YoutubeSquare { get { return UnicodeToChar("f166"); } }
  public static string Youtube { get { return UnicodeToChar("f167"); } }
  public static string Xing { get { return UnicodeToChar("f168"); } }
  public static string XingSquare { get { return UnicodeToChar("f169"); } }
  public static string YoutubePlay { get { return UnicodeToChar("f16a"); } }
  public static string Dropbox { get { return UnicodeToChar("f16b"); } }
  public static string StackOverflow { get { return UnicodeToChar("f16c"); } }
  public static string Instagram { get { return UnicodeToChar("f16d"); } }
  public static string Flickr { get { return UnicodeToChar("f16e"); } }
  public static string Adn { get { return UnicodeToChar("f170"); } }
  public static string Bitbucket { get { return UnicodeToChar("f171"); } }
  public static string BitbucketSquare { get { return UnicodeToChar("f172"); } }
  public static string Tumblr { get { return UnicodeToChar("f173"); } }
  public static string TumblrSquare { get { return UnicodeToChar("f174"); } }
  public static string LongArrowDown { get { return UnicodeToChar("f175"); } }
  public static string LongArrowUp { get { return UnicodeToChar("f176"); } }
  public static string LongArrowLeft { get { return UnicodeToChar("f177"); } }
  public static string LongArrowRight { get { return UnicodeToChar("f178"); } }
  public static string Apple { get { return UnicodeToChar("f179"); } }
  public static string Windows { get { return UnicodeToChar("f17a"); } }
  public static string Android { get { return UnicodeToChar("f17b"); } }
  public static string Linux { get { return UnicodeToChar("f17c"); } }
  public static string Dribbble { get { return UnicodeToChar("f17d"); } }
  public static string Skype { get { return UnicodeToChar("f17e"); } }
  public static string Foursquare { get { return UnicodeToChar("f180"); } }
  public static string Trello { get { return UnicodeToChar("f181"); } }
  public static string Female { get { return UnicodeToChar("f182"); } }
  public static string Male { get { return UnicodeToChar("f183"); } }
  public static string Gittip { get { return UnicodeToChar("f184"); } }
  public static string Gratipay { get { return UnicodeToChar("f184"); } }
  public static string SunO { get { return UnicodeToChar("f185"); } }
  public static string MoonO { get { return UnicodeToChar("f186"); } }
  public static string Archive { get { return UnicodeToChar("f187"); } }
  public static string Bug { get { return UnicodeToChar("f188"); } }
  public static string Vk { get { return UnicodeToChar("f189"); } }
  public static string Weibo { get { return UnicodeToChar("f18a"); } }
  public static string Renren { get { return UnicodeToChar("f18b"); } }
  public static string Pagelines { get { return UnicodeToChar("f18c"); } }
  public static string StackExchange { get { return UnicodeToChar("f18d"); } }
  public static string ArrowCircleORight { get { return UnicodeToChar("f18e"); } }
  public static string ArrowCircleOLeft { get { return UnicodeToChar("f190"); } }
  public static string ToggleLeft { get { return UnicodeToChar("f191"); } }
  public static string CaretSquareOLeft { get { return UnicodeToChar("f191"); } }
  public static string DotCircleO { get { return UnicodeToChar("f192"); } }
  public static string Wheelchair { get { return UnicodeToChar("f193"); } }
  public static string VimeoSquare { get { return UnicodeToChar("f194"); } }
  public static string TurkishLira { get { return UnicodeToChar("f195"); } }
  public static string Try { get { return UnicodeToChar("f195"); } }
  public static string PlusSquareO { get { return UnicodeToChar("f196"); } }
  public static string SpaceShuttle { get { return UnicodeToChar("f197"); } }
  public static string Slack { get { return UnicodeToChar("f198"); } }
  public static string EnvelopeSquare { get { return UnicodeToChar("f199"); } }
  public static string Wordpress { get { return UnicodeToChar("f19a"); } }
  public static string Openid { get { return UnicodeToChar("f19b"); } }
  public static string Institution { get { return UnicodeToChar("f19c"); } }
  public static string Bank { get { return UnicodeToChar("f19c"); } }
  public static string University { get { return UnicodeToChar("f19c"); } }
  public static string MortarBoard { get { return UnicodeToChar("f19d"); } }
  public static string GraduationCap { get { return UnicodeToChar("f19d"); } }
  public static string Yahoo { get { return UnicodeToChar("f19e"); } }
  public static string Google { get { return UnicodeToChar("f1a0"); } }
  public static string Reddit { get { return UnicodeToChar("f1a1"); } }
  public static string RedditSquare { get { return UnicodeToChar("f1a2"); } }
  public static string StumbleuponCircle { get { return UnicodeToChar("f1a3"); } }
  public static string Stumbleupon { get { return UnicodeToChar("f1a4"); } }
  public static string Delicious { get { return UnicodeToChar("f1a5"); } }
  public static string Digg { get { return UnicodeToChar("f1a6"); } }
  public static string PiedPiper { get { return UnicodeToChar("f1a7"); } }
  public static string PiedPiperAlt { get { return UnicodeToChar("f1a8"); } }
  public static string Drupal { get { return UnicodeToChar("f1a9"); } }
  public static string Joomla { get { return UnicodeToChar("f1aa"); } }
  public static string Language { get { return UnicodeToChar("f1ab"); } }
  public static string Fax { get { return UnicodeToChar("f1ac"); } }
  public static string Building { get { return UnicodeToChar("f1ad"); } }
  public static string Child { get { return UnicodeToChar("f1ae"); } }
  public static string Paw { get { return UnicodeToChar("f1b0"); } }
  public static string Spoon { get { return UnicodeToChar("f1b1"); } }
  public static string Cube { get { return UnicodeToChar("f1b2"); } }
  public static string Cubes { get { return UnicodeToChar("f1b3"); } }
  public static string Behance { get { return UnicodeToChar("f1b4"); } }
  public static string BehanceSquare { get { return UnicodeToChar("f1b5"); } }
  public static string Steam { get { return UnicodeToChar("f1b6"); } }
  public static string SteamSquare { get { return UnicodeToChar("f1b7"); } }
  public static string Recycle { get { return UnicodeToChar("f1b8"); } }
  public static string Automobile { get { return UnicodeToChar("f1b9"); } }
  public static string Car { get { return UnicodeToChar("f1b9"); } }
  public static string Cab { get { return UnicodeToChar("f1ba"); } }
  public static string Taxi { get { return UnicodeToChar("f1ba"); } }
  public static string Tree { get { return UnicodeToChar("f1bb"); } }
  public static string Spotify { get { return UnicodeToChar("f1bc"); } }
  public static string Deviantart { get { return UnicodeToChar("f1bd"); } }
  public static string Soundcloud { get { return UnicodeToChar("f1be"); } }
  public static string Database { get { return UnicodeToChar("f1c0"); } }
  public static string FilePdfO { get { return UnicodeToChar("f1c1"); } }
  public static string FileWordO { get { return UnicodeToChar("f1c2"); } }
  public static string FileExcelO { get { return UnicodeToChar("f1c3"); } }
  public static string FilePowerpointO { get { return UnicodeToChar("f1c4"); } }
  public static string FilePhotoO { get { return UnicodeToChar("f1c5"); } }
  public static string FilePictureO { get { return UnicodeToChar("f1c5"); } }
  public static string FileImageO { get { return UnicodeToChar("f1c5"); } }
  public static string FileZipO { get { return UnicodeToChar("f1c6"); } }
  public static string FileArchiveO { get { return UnicodeToChar("f1c6"); } }
  public static string FileSoundO { get { return UnicodeToChar("f1c7"); } }
  public static string FileAudioO { get { return UnicodeToChar("f1c7"); } }
  public static string FileMovieO { get { return UnicodeToChar("f1c8"); } }
  public static string FileVideoO { get { return UnicodeToChar("f1c8"); } }
  public static string FileCodeO { get { return UnicodeToChar("f1c9"); } }
  public static string Vine { get { return UnicodeToChar("f1ca"); } }
  public static string Codepen { get { return UnicodeToChar("f1cb"); } }
  public static string Jsfiddle { get { return UnicodeToChar("f1cc"); } }
  public static string LifeBouy { get { return UnicodeToChar("f1cd"); } }
  public static string LifeBuoy { get { return UnicodeToChar("f1cd"); } }
  public static string LifeSaver { get { return UnicodeToChar("f1cd"); } }
  public static string Support { get { return UnicodeToChar("f1cd"); } }
  public static string LifeRing { get { return UnicodeToChar("f1cd"); } }
  public static string CircleONotch { get { return UnicodeToChar("f1ce"); } }
  public static string Ra { get { return UnicodeToChar("f1d0"); } }
  public static string Rebel { get { return UnicodeToChar("f1d0"); } }
  public static string Ge { get { return UnicodeToChar("f1d1"); } }
  public static string Empire { get { return UnicodeToChar("f1d1"); } }
  public static string GitSquare { get { return UnicodeToChar("f1d2"); } }
  public static string Git { get { return UnicodeToChar("f1d3"); } }
  public static string YCombinatorSquare { get { return UnicodeToChar("f1d4"); } }
  public static string YcSquare { get { return UnicodeToChar("f1d4"); } }
  public static string HackerNews { get { return UnicodeToChar("f1d4"); } }
  public static string TencentWeibo { get { return UnicodeToChar("f1d5"); } }
  public static string Qq { get { return UnicodeToChar("f1d6"); } }
  public static string Wechat { get { return UnicodeToChar("f1d7"); } }
  public static string Weixin { get { return UnicodeToChar("f1d7"); } }
  public static string Send { get { return UnicodeToChar("f1d8"); } }
  public static string PaperPlane { get { return UnicodeToChar("f1d8"); } }
  public static string SendO { get { return UnicodeToChar("f1d9"); } }
  public static string PaperPlaneO { get { return UnicodeToChar("f1d9"); } }
  public static string History { get { return UnicodeToChar("f1da"); } }
  public static string CircleThin { get { return UnicodeToChar("f1db"); } }
  public static string Header { get { return UnicodeToChar("f1dc"); } }
  public static string Paragraph { get { return UnicodeToChar("f1dd"); } }
  public static string Sliders { get { return UnicodeToChar("f1de"); } }
  public static string ShareAlt { get { return UnicodeToChar("f1e0"); } }
  public static string ShareAltSquare { get { return UnicodeToChar("f1e1"); } }
  public static string Bomb { get { return UnicodeToChar("f1e2"); } }
  public static string SoccerBallO { get { return UnicodeToChar("f1e3"); } }
  public static string FutbolO { get { return UnicodeToChar("f1e3"); } }
  public static string Tty { get { return UnicodeToChar("f1e4"); } }
  public static string Binoculars { get { return UnicodeToChar("f1e5"); } }
  public static string Plug { get { return UnicodeToChar("f1e6"); } }
  public static string Slideshare { get { return UnicodeToChar("f1e7"); } }
  public static string Twitch { get { return UnicodeToChar("f1e8"); } }
  public static string Yelp { get { return UnicodeToChar("f1e9"); } }
  public static string NewspaperO { get { return UnicodeToChar("f1ea"); } }
  public static string Wifi { get { return UnicodeToChar("f1eb"); } }
  public static string Calculator { get { return UnicodeToChar("f1ec"); } }
  public static string Paypal { get { return UnicodeToChar("f1ed"); } }
  public static string GoogleWallet { get { return UnicodeToChar("f1ee"); } }
  public static string CcVisa { get { return UnicodeToChar("f1f0"); } }
  public static string CcMastercard { get { return UnicodeToChar("f1f1"); } }
  public static string CcDiscover { get { return UnicodeToChar("f1f2"); } }
  public static string CcAmex { get { return UnicodeToChar("f1f3"); } }
  public static string CcPaypal { get { return UnicodeToChar("f1f4"); } }
  public static string CcStripe { get { return UnicodeToChar("f1f5"); } }
  public static string BellSlash { get { return UnicodeToChar("f1f6"); } }
  public static string BellSlashO { get { return UnicodeToChar("f1f7"); } }
  public static string Trash { get { return UnicodeToChar("f1f8"); } }
  public static string Copyright { get { return UnicodeToChar("f1f9"); } }
  public static string At { get { return UnicodeToChar("f1fa"); } }
  public static string Eyedropper { get { return UnicodeToChar("f1fb"); } }
  public static string PaintBrush { get { return UnicodeToChar("f1fc"); } }
  public static string BirthdayCake { get { return UnicodeToChar("f1fd"); } }
  public static string AreaChart { get { return UnicodeToChar("f1fe"); } }
  public static string PieChart { get { return UnicodeToChar("f200"); } }
  public static string LineChart { get { return UnicodeToChar("f201"); } }
  public static string Lastfm { get { return UnicodeToChar("f202"); } }
  public static string LastfmSquare { get { return UnicodeToChar("f203"); } }
  public static string ToggleOff { get { return UnicodeToChar("f204"); } }
  public static string ToggleOn { get { return UnicodeToChar("f205"); } }
  public static string Bicycle { get { return UnicodeToChar("f206"); } }
  public static string Bus { get { return UnicodeToChar("f207"); } }
  public static string Ioxhost { get { return UnicodeToChar("f208"); } }
  public static string Angellist { get { return UnicodeToChar("f209"); } }
  public static string Cc { get { return UnicodeToChar("f20a"); } }
  public static string Shekel { get { return UnicodeToChar("f20b"); } }
  public static string Sheqel { get { return UnicodeToChar("f20b"); } }
  public static string Ils { get { return UnicodeToChar("f20b"); } }
  public static string Meanpath { get { return UnicodeToChar("f20c"); } }
  public static string Buysellads { get { return UnicodeToChar("f20d"); } }
  public static string Connectdevelop { get { return UnicodeToChar("f20e"); } }
  public static string Dashcube { get { return UnicodeToChar("f210"); } }
  public static string Forumbee { get { return UnicodeToChar("f211"); } }
  public static string Leanpub { get { return UnicodeToChar("f212"); } }
  public static string Sellsy { get { return UnicodeToChar("f213"); } }
  public static string Shirtsinbulk { get { return UnicodeToChar("f214"); } }
  public static string Simplybuilt { get { return UnicodeToChar("f215"); } }
  public static string Skyatlas { get { return UnicodeToChar("f216"); } }
  public static string CartPlus { get { return UnicodeToChar("f217"); } }
  public static string CartArrowDown { get { return UnicodeToChar("f218"); } }
  public static string Diamond { get { return UnicodeToChar("f219"); } }
  public static string Ship { get { return UnicodeToChar("f21a"); } }
  public static string UserSecret { get { return UnicodeToChar("f21b"); } }
  public static string Motorcycle { get { return UnicodeToChar("f21c"); } }
  public static string StreetView { get { return UnicodeToChar("f21d"); } }
  public static string Heartbeat { get { return UnicodeToChar("f21e"); } }
  public static string Venus { get { return UnicodeToChar("f221"); } }
  public static string Mars { get { return UnicodeToChar("f222"); } }
  public static string Mercury { get { return UnicodeToChar("f223"); } }
  public static string Intersex { get { return UnicodeToChar("f224"); } }
  public static string Transgender { get { return UnicodeToChar("f224"); } }
  public static string TransgenderAlt { get { return UnicodeToChar("f225"); } }
  public static string VenusDouble { get { return UnicodeToChar("f226"); } }
  public static string MarsDouble { get { return UnicodeToChar("f227"); } }
  public static string VenusMars { get { return UnicodeToChar("f228"); } }
  public static string MarsStroke { get { return UnicodeToChar("f229"); } }
  public static string MarsStrokeV { get { return UnicodeToChar("f22a"); } }
  public static string MarsStrokeH { get { return UnicodeToChar("f22b"); } }
  public static string Neuter { get { return UnicodeToChar("f22c"); } }
  public static string Genderless { get { return UnicodeToChar("f22d"); } }
  public static string FacebookOfficial { get { return UnicodeToChar("f230"); } }
  public static string PinterestP { get { return UnicodeToChar("f231"); } }
  public static string Whatsapp { get { return UnicodeToChar("f232"); } }
  public static string Server { get { return UnicodeToChar("f233"); } }
  public static string UserPlus { get { return UnicodeToChar("f234"); } }
  public static string UserTimes { get { return UnicodeToChar("f235"); } }
  public static string Hotel { get { return UnicodeToChar("f236"); } }
  public static string Bed { get { return UnicodeToChar("f236"); } }
  public static string Viacoin { get { return UnicodeToChar("f237"); } }
  public static string Train { get { return UnicodeToChar("f238"); } }
  public static string Subway { get { return UnicodeToChar("f239"); } }
  public static string Medium { get { return UnicodeToChar("f23a"); } }
  public static string Yc { get { return UnicodeToChar("f23b"); } }
  public static string YCombinator { get { return UnicodeToChar("f23b"); } }
  public static string OptinMonster { get { return UnicodeToChar("f23c"); } }
  public static string Opencart { get { return UnicodeToChar("f23d"); } }
  public static string Expeditedssl { get { return UnicodeToChar("f23e"); } }
  public static string Battery4 { get { return UnicodeToChar("f240"); } }
  public static string BatteryFull { get { return UnicodeToChar("f240"); } }
  public static string Battery3 { get { return UnicodeToChar("f241"); } }
  public static string BatteryThreeQuarters { get { return UnicodeToChar("f241"); } }
  public static string Battery2 { get { return UnicodeToChar("f242"); } }
  public static string BatteryHalf { get { return UnicodeToChar("f242"); } }
  public static string Battery1 { get { return UnicodeToChar("f243"); } }
  public static string BatteryQuarter { get { return UnicodeToChar("f243"); } }
  public static string Battery0 { get { return UnicodeToChar("f244"); } }
  public static string BatteryEmpty { get { return UnicodeToChar("f244"); } }
  public static string MousePointer { get { return UnicodeToChar("f245"); } }
  // ReSharper disable once InconsistentNaming
  public static string Cursor_ { get { return UnicodeToChar("f246"); } }
  public static string ObjectGroup { get { return UnicodeToChar("f247"); } }
  public static string ObjectUngroup { get { return UnicodeToChar("f248"); } }
  public static string StickyNote { get { return UnicodeToChar("f249"); } }
  public static string StickyNoteO { get { return UnicodeToChar("f24a"); } }
  public static string CcJcb { get { return UnicodeToChar("f24b"); } }
  public static string CcDinersClub { get { return UnicodeToChar("f24c"); } }
  public static string Clone { get { return UnicodeToChar("f24d"); } }
  public static string BalanceScale { get { return UnicodeToChar("f24e"); } }
  public static string HourglassO { get { return UnicodeToChar("f250"); } }
  public static string Hourglass1 { get { return UnicodeToChar("f251"); } }
  public static string HourglassStart { get { return UnicodeToChar("f251"); } }
  public static string Hourglass2 { get { return UnicodeToChar("f252"); } }
  public static string HourglassHalf { get { return UnicodeToChar("f252"); } }
  public static string Hourglass3 { get { return UnicodeToChar("f253"); } }
  public static string HourglassEnd { get { return UnicodeToChar("f253"); } }
  public static string Hourglass { get { return UnicodeToChar("f254"); } }
  public static string HandGrabO { get { return UnicodeToChar("f255"); } }
  public static string HandRockO { get { return UnicodeToChar("f255"); } }
  public static string HandStopO { get { return UnicodeToChar("f256"); } }
  public static string HandPaperO { get { return UnicodeToChar("f256"); } }
  public static string HandScissorsO { get { return UnicodeToChar("f257"); } }
  public static string HandLizardO { get { return UnicodeToChar("f258"); } }
  public static string HandSpockO { get { return UnicodeToChar("f259"); } }
  public static string HandPointerO { get { return UnicodeToChar("f25a"); } }
  public static string HandPeaceO { get { return UnicodeToChar("f25b"); } }
  public static string Trademark { get { return UnicodeToChar("f25c"); } }
  public static string Registered { get { return UnicodeToChar("f25d"); } }
  public static string CreativeCommons { get { return UnicodeToChar("f25e"); } }
  public static string Gg { get { return UnicodeToChar("f260"); } }
  public static string GgCircle { get { return UnicodeToChar("f261"); } }
  public static string Tripadvisor { get { return UnicodeToChar("f262"); } }
  public static string Odnoklassniki { get { return UnicodeToChar("f263"); } }
  public static string OdnoklassnikiSquare { get { return UnicodeToChar("f264"); } }
  public static string GetPocket { get { return UnicodeToChar("f265"); } }
  public static string WikipediaW { get { return UnicodeToChar("f266"); } }
  public static string Safari { get { return UnicodeToChar("f267"); } }
  public static string Chrome { get { return UnicodeToChar("f268"); } }
  public static string Firefox { get { return UnicodeToChar("f269"); } }
  public static string Opera { get { return UnicodeToChar("f26a"); } }
  public static string InternetExplorer { get { return UnicodeToChar("f26b"); } }
  public static string Tv { get { return UnicodeToChar("f26c"); } }
  public static string Television { get { return UnicodeToChar("f26c"); } }
  public static string Contao { get { return UnicodeToChar("f26d"); } }
  // ReSharper disable once InconsistentNaming
  public static string _500px { get { return UnicodeToChar("f26e"); } }
  public static string Amazon { get { return UnicodeToChar("f270"); } }
  public static string CalendarPlusO { get { return UnicodeToChar("f271"); } }
  public static string CalendarMinusO { get { return UnicodeToChar("f272"); } }
  public static string CalendarTimesO { get { return UnicodeToChar("f273"); } }
  public static string CalendarCheckO { get { return UnicodeToChar("f274"); } }
  public static string Industry { get { return UnicodeToChar("f275"); } }
  public static string MapPin { get { return UnicodeToChar("f276"); } }
  public static string MapSigns { get { return UnicodeToChar("f277"); } }
  public static string MapO { get { return UnicodeToChar("f278"); } }
  public static string Map { get { return UnicodeToChar("f279"); } }
  public static string Commenting { get { return UnicodeToChar("f27a"); } }
  public static string CommentingO { get { return UnicodeToChar("f27b"); } }
  public static string Houzz { get { return UnicodeToChar("f27c"); } }
  public static string Vimeo { get { return UnicodeToChar("f27d"); } }
  public static string BlackTie { get { return UnicodeToChar("f27e"); } }
  public static string Fonticons { get { return UnicodeToChar("f280"); } }
}
"@
#} 

#Add-Type -path $PSScriptRoot\FontAwesome.dll -ErrorAction Ignore
[Fa]::TtfFilePath = "$PSScriptRoot\fontawesome-webfont.ttf"
