#######################################################################################
# WinForm with a SplitContainer to host 2 Windows File Explorers
# System.Windows.Forms.SplitContainer is a simple dual panel controller with a draggable splitter in the middle - how convenient!

#########################################################################################################################
#########################################################################################################################
#
# Latest source here: https://beejpowershell.codeplex.com/SourceControl/latest#PoshDualExplorers/PoshDualExplorers.ps1
#
#########################################################################################################################
#########################################################################################################################

# helpful posts
# http://www.codeproject.com/Articles/101367/Code-to-Host-a-Third-Party-Application-in-our-Proc
# http://www.codedisqus.com/CNVqVXqgUV/how-to-find-a-desktop-window-by-window-name-in-windows-81-update-2-os-using-the-win32-api-findwindow-in-powershell-environment.html
# http://www.catch22.net/software/winspy-17
# http://social.technet.microsoft.com/wiki/contents/articles/26207.how-to-add-a-powershell-gui-event-handler-with-parameters-part-2.aspx
# http://poshcode.org/4206
# https://gallery.technet.microsoft.com/scriptcenter/dd9d04c2-592b-4eb5-bb09-cd5725d35e68
# http://stackoverflow.com/questions/2518257/get-the-selected-file-in-an-explorer-window
# http://stackoverflow.com/questions/14193388/how-to-get-windows-explorers-selected-files-from-within-c
# http://windowsitpro.com/scripting/understanding-vbscript-shell-object-model-s-folder-and-folderitem-objects

# these two posts in particular showed me the approach that worked out for the file copy piece
#   http://blog.backslasher.net/copying-files-in-powershell-using-windows-explorer-ui.html
#   http://stackoverflow.com/questions/8292953/get-current-selection-in-windowsexplorer-from-a-c-sharp-application

$Error.Clear()

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Add-Type -Path $PSScriptRoot\Interop.SHDocVw.dll

# https://github.com/denwilliams/FontAwesome-WindowsForms
Add-Type -path $PSScriptRoot\FontAwesomeIcons.dll 

#save the compiled user32 exports wrapper to see if we can spin up faster... in my testing it didn't seem to make a difference
if (Test-path $PSScriptRoot\user32.dll) { Add-Type -path $PSScriptRoot\user32.dll }
else {
Add-Type -OutputAssembly $PSScriptRoot\user32.dll -TypeDefinition @"

using System;
using System.Runtime.InteropServices;
using System.Text;

public class User32 {

    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
    public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);
    public static readonly IntPtr HWND_TOP = new IntPtr(0);
    public static readonly IntPtr HWND_BOTTOM = new IntPtr(1);

    public static readonly int
        NOSIZE = 0x0001,
        NOMOVE = 0x0002,
        NOZORDER = 0x0004,
        NOREDRAW = 0x0008,
        NOACTIVATE = 0x0010,
        DRAWFRAME = 0x0020,
        FRAMECHANGED = 0x0020,
        SHOWWINDOW = 0x0040,
        HIDEWINDOW = 0x0080,
        NOCOPYBITS = 0x0100,
        NOOWNERZORDER = 0x0200,
        NOREPOSITION = 0x0200,
        NOSENDCHANGING = 0x0400,
        DEFERERASE = 0x2000,
        ASYNCWINDOWPOS = 0x4000,
        GWL_STYLE = -16,
        GWL_EXSTYLE = -20,
        WM_SYSCOMMAND = 0x0112,
        SC_CLOSE = 0xF060,

        WS_BORDER = 0x00800000,
        WS_DLGFRAME = 0x00400000,
        WS_CAPTION = WS_BORDER | WS_DLGFRAME,
        WS_SYSMENU = 524288,
        WS_THICKFRAME = 262144,
        WS_MINIMIZE = 536870912,
        WS_MAXIMIZEBOX = 65536,
            
        SWP_NOMOVE = 0x2,
        SWP_NOSIZE = 0x1,
        SWP_FRAMECHANGED = 0x20,
        MF_BYPOSITION = 0x400,
        MF_REMOVE = 0x1000,
            
        // Values for ShowWindowAsync(nCmdShow)
        SW_HIDE = 0, 
        SW_SHOWNORMAL = 1, 
        SW_NORMAL = 1, 
        SW_SHOWMINIMIZED = 2, 
        SW_SHOWMAXIMIZED = 3, 
        SW_MAXIMIZE = 3, 
        SW_SHOWNOACTIVATE = 4, 
        SW_SHOW = 5, 
        SW_MINIMIZE = 6, 
        SW_SHOWMINNOACTIVE = 7, 
        SW_SHOWNA = 8, 
        SW_RESTORE = 9, 
        SW_SHOWDEFAULT = 10, 
        SW_MAX = 10;

    public static readonly uint
        WS_POPUP = 0x80000000,
        WS_CHILD = 0x40000000;

    public static readonly long
        WS_EX_DLGMODALFRAME = 0x1L;


    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindow(String sClassName, String sAppName);

    [DllImport("user32.dll")]
    public static extern int SendMessage(int hWnd, uint Msg, int wParam, int lParam);

    [DllImport("kernel32.dll")]
    public static extern uint GetLastError();

    [DllImport("user32.dll")]
    public static extern IntPtr SetParent(IntPtr hWnd,IntPtr hWndNewParent);

    [DllImport("user32.dll")]
    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    //from here: http://stackoverflow.com/questions/2825528/removing-the-title-bar-of-external-application-using-c-sharp
    public static void HideTitleBar(IntPtr hWnd) {
        var style = GetWindowLong(hWnd, GWL_STYLE);
        style = style & ~WS_CAPTION;
        style = style & ~WS_SYSMENU;
        style = style & ~WS_THICKFRAME;
        style = style & ~WS_MINIMIZE;
        style = style & ~WS_MAXIMIZEBOX;
        SetWindowLong(hWnd, GWL_STYLE, style);
    }

    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public enum EXTENDED_NAME_FORMAT
    {
        NameUnknown = 0,
        NameFullyQualifiedDN = 1,
        NameSamCompatible = 2,
        NameDisplay = 3,
        NameUniqueId = 6,
        NameCanonical = 7,
        NameUserPrincipal = 8,
        NameCanonicalEx = 9,
        NameServicePrincipal = 10,
        NameDnsDomain = 12
    }

    [DllImport("secur32.dll", CharSet=CharSet.Auto, SetLastError=true)]
    [return: MarshalAs(UnmanagedType.I4)]
    public static extern int GetUserNameEx (EXTENDED_NAME_FORMAT nameFormat, StringBuilder userName, ref uint userNameSize);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@ 
Add-Type -path $PSScriptRoot\user32.dll
}

#nugget: don't use -WindowStyle Hidden on the ps1 shortcut, it prevents retrieval of main MainWindowHandle here...
#save MainWindowHandle so we can hide explicitly here and be available to show at end for troubleshooting IIF PowerShell errors were emitted
$process = Get-Process -Id $pid
$poShConsoleHwnd = $process.MainWindowHandle
if ($process.ProcessName -eq "powershell_ise") { $poShConsoleHwnd=0 }
function showPoShConsole {
  param([bool]$show = $true)
  
  if ($show -and [User32]::IsWindowVisible($poShConsoleHwnd)) { $show=$false }

  [User32]::ShowWindowAsync($poShConsoleHwnd, @([User32]::SW_HIDE, [User32]::SW_SHOWNORMAL)[$show]) | Out-Null
  [User32]::SetForegroundWindow($poShConsoleHwnd) | Out-Null
}

showPoShConsole $false

# http://www.codeproject.com/Articles/101367/Code-to-Host-a-Third-Party-Application-in-our-Proc
$splitContainer_Resize =
{
  if (!$tabContainerLeft -or !$tabContainerLeft.SelectedTab -or !$tabContainerLeft.SelectedTab.Tag.Hwnd) { return }
  $tab = $tabContainerLeft.SelectedTab
  [User32]::SetWindowPos(
    $tab.Tag.Hwnd,
    [User32]::HWND_TOP,
    $tab.ClientRectangle.Left,
    $tab.ClientRectangle.Top,
    $tab.ClientRectangle.Width,
    $tab.ClientRectangle.Height,
    [User32]::NOACTIVATE -bor [User32]::SHOWWINDOW
  ) | Out-Null

  if (!$tabContainerRight -or !$tabContainerRight.SelectedTab -or !$tabContainerRight.SelectedTab.Tag.Hwnd) { return }
  $tab = $tabContainerRight.SelectedTab
  [User32]::SetWindowPos(
    $tab.Tag.Hwnd,
    [User32]::HWND_TOP,
    $tab.ClientRectangle.Left,
    $tab.ClientRectangle.Top,
    $tab.ClientRectangle.Width,
    $tab.ClientRectangle.Height,
    [User32]::NOACTIVATE -bor [User32]::SHOWWINDOW
  ) | Out-Null
}

function createButton {
  param( [string]$toolTipText, [FontAwesomeIcons.IconType]$iconType, $eventHandler )

  $faButton = New-Object FontAwesomeIcons.IconButton
  ([System.ComponentModel.ISupportInitialize]($faButton)).BeginInit()
  $faButton.ActiveColor = [System.Drawing.Color]::Blue
  $faButton.BackColor = [System.Drawing.Color]::LightGray
  $faButton.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $faButton.IconType = $iconType
  $faButton.InActiveColor = [System.Drawing.Color]::Black
  #$faButton.Location = new-object System.Drawing.Point(255, 191)
  #$faButton.Name = "iconButton4"
  $faButton.Size = new-object System.Drawing.Size(60, 60)
  #$faButton.TabIndex = 4
  #$faButton.TabStop = false
  $faButton.ToolTipText = $toolTipText
  $faButton.Add_Click($eventHandler)

  return $faButton
}

function closeTab {
  param([System.Windows.Forms.TabPage]$tabPage)

  [User32]::SendMessage($tabPage.Tag.Hwnd, [User32]::WM_SYSCOMMAND, [User32]::SC_CLOSE, 0) | Out-Null
  $tabPage.Tag.TabControl.TabPages.Remove($tabPage)
}


#a stream of bummers drove a little extra code complexity here...
#$objShell.Explore($env:USERPROFILE) yields a window title with the user's "display" name vs their USERPROFILE/"account" name but we have to locate the window handle by title...hmmm
#Start-Process makes a easy to find title but all forms i tried were creating new explorer.exe processes which seemed like overkill...
#  e.g. Start-Process -FilePath "explorer.exe" -ArgumentList "$env:USERPROFILE"
#System.DirectoryServices.AccountManagement.UserPrincipal.Current.DisplayName would allow us to find window, but .Current was taking 5 seconds?!? presumably to timeout on finding a DC (on a non domain PC? braindead MS??)...
#so found the GetUserNameEx Win32API approach
$userDisplayName = New-Object System.Text.StringBuilder -ArgumentList 1024
[User32]::GetUserNameEx([int][User32+EXTENDED_NAME_FORMAT]::NameDisplay, $userDisplayName, [ref] $userDisplayName.Capacity) | Out-Null #nugget: embedded C# enum syntax

function newFileExTab {
  param([bool]$leftSide, [string]$folderPath)

  $tabPage = New-Object System.Windows.Forms.TabPage
  $tabContainer = @($tabContainerRight, $tabContainerLeft)[$leftSide]
  $tabPage.Text = "Tab" + ($tabContainer.TabCount + 1)

  $tabContainer.TabPages.Add($tabPage)
  $tabContainer.SelectedIndex = $tabContainer.TabCount-1

  #launch a new file explorer with a known path, which drives a known window title we can lock in on and manipulate further
  $objShell.Explore($env:USERPROFILE)

  # if these windows class lookups change over Win.next, WinSpy tool is our friend:
  # http://www.catch22.net/software/winspy-17
  do { $hwnd = [User32]::FindWindow("CabinetWClass", [string]$userDisplayName) } while ( $hwnd -eq 0 )
  #snag and save the individual "Window" interface (SHDocVw.InternetExplorer) for each of our File Explorers - to be used later for pulling the currently selected items in the CopyFile code
  do { $shDocVw = $shellWindows | ?{$_.HWND -eq $hwnd} } while ( !$shDocVw ) #my quick testing showed this would cycle 8 to 12 times before quiescing to a value
  
  # good 'ol User32 SetParent()
  # i know it's silly but actually trying this right here with our old friend explorer.exe has been haunting me literally for years
  [User32]::SetParent($hwnd, $tabPage.Handle) | Out-Null
  [User32]::HideTitleBar($hwnd)

  $tabPage.Tag = New-Object –TypeName PSObject -Property @{ ShDocVw=$shDocVw; Hwnd=$hwnd; TabControl=$tabContainer }

  $splitContainer_Resize.Invoke()

  if ($folderPath) { @((rightShell), (leftShell))[$leftSide].Navigate($folderPath) }
}


function uriToWindowsPath {
  param([string]$uri)

  return [uri]::UnEscapeDataString($uri).Replace("file:///", "").Replace("/", [char]92) #char92 just hides slash character from blog > google prettyprint munging
}

function leftShell { return $tabContainerLeft.SelectedTab.Tag.ShDocVw }
function rightShell { return $tabContainerRight.SelectedTab.Tag.ShDocVw }
function leftPath { return uriToWindowsPath (leftShell).LocationUrl }
function rightPath { return uriToWindowsPath (rightShell).LocationUrl }
function leftSelectedItems { (leftShell).Document.SelectedItems() }
function rightSelectedItems { (rightShell).Document.SelectedItems() }
function leftFirstSelectedPath { $items = leftSelectedItems; if ($items.Count -gt 0) { $items.Item(0).Path } }
function rightFirstSelectedPath { $items = rightSelectedItems; if ($items.Count -gt 0) { $items.Item(0).Path } }

function copyLeftToRight {
  param([bool]$move)

  #debug: [System.Windows.Forms.MessageBox]::Show($explorerLeft_SHDocVw.Document.FocusedItem.Path)
  #debug: [System.Windows.Forms.MessageBox]::Show($explorerRight_SHDocVw.LocationUrl)
  
  # these two posts are what showed me the approach that worked here          
  #   http://blog.backslasher.net/copying-files-in-powershell-using-windows-explorer-ui.html
  #   http://stackoverflow.com/questions/8292953/get-current-selection-in-windowsexplorer-from-a-c-sharp-application

  $rightFolder = $objShell.NameSpace((rightPath))
  #when SHDocVw.InternetExplorer is hosting a File Explorer vs IE, it's .Document property then implements the Shell32.IShellFolderViewDual interface (among others, but this is the one we care about here)
  # => https://msdn.microsoft.com/en-us/library/windows/desktop/dd894076(v=vs.85).aspx

  #so then Shell32.IShellFolderViewDual.SelectedItems gives us a FolderItems collection => https://msdn.microsoft.com/en-us/library/windows/desktop/bb787800(v=vs.85).aspx
  # which naturally contains a list of FolderItem => https://msdn.microsoft.com/en-us/library/windows/desktop/bb787810(v=vs.85).aspx
  # but we're actually on interested in the collection itself in this case
  # and it's interesting that the Shell.Application.CopyHere method is compatible with the objects obtained from SHDocVw...
  # i.e. one starts to see that as obtuse as all these interfaces seem at first, they do actually hang together

  # Folder.CopyHere - https://msdn.microsoft.com/en-us/library/windows/desktop/bb787866%28v=vs.85%29.aspx
  @($rightFolder.CopyHere, $rightFolder.MoveHere)[$move].Invoke((leftShell).Document.SelectedItems()) #interesting, couldn't pass FolderItems collection as function result, would always only do first item
}

# https://msdn.microsoft.com/en-us/library/windows/desktop/bb787866%28v=vs.85%29.aspx
$objShell = New-Object -ComObject "Shell.Application"

#Shell.Application::Windows() gives us a collection of "SHDocVw.InternetExplorer" objects: https://msdn.microsoft.com/en-us/library/aa752084(v=vs.85).aspx
#which is goofy naming since this has nothing to do with IE but that's obviously just the way MS baked the shared UI components together
$shellWindows = $objShell.Windows()

$splitContainer = new-object System.Windows.Forms.SplitContainer
$splitContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
$splitContainer.SplitterWidth = 20
$splitContainer.Add_SplitterMoving($splitContainer_Resize)
$splitContainer.Add_SplitterMoved($splitContainer_Resize)

$tabContainerLeft = new-object System.Windows.Forms.TabControl
$tabContainerLeft.Dock = "fill"
$tabContainerLeft.Add_DoubleClick({ closeTab $tabContainerLeft.SelectedTab }) #nugget: doubleClick on the TabPage header actually registers on the TabControl vs the TabPage
$splitContainer.Panel1.Controls.Add($tabContainerLeft)

$tabContainerRight = new-object System.Windows.Forms.TabControl
$tabContainerRight.Dock = "fill"
$tabContainerRight.Add_DoubleClick({ closeTab $tabContainerRight.SelectedTab })
$splitContainer.Panel2.Controls.Add($tabContainerRight)

$frmMain = New-Object System.Windows.Forms.Form
$frmMain.Text = "DuEx"
$frmMain.KeyPreview = $true
$frmMain.Icon = New-Object system.drawing.icon ("$PSScriptRoot\DualFileExplorers.ico")
$frmMain.WindowState = "Maximized";
$frmMain.Controls.Add($splitContainer)
$frmMain.Add_Resize($splitContainer_Resize)
$splitContainer.SplitterDistance = $frmMain.ClientRectangle.Width / 2;

#button toolbar
#https://adminscache.wordpress.com/2014/08/03/powershell-winforms-menu/
$buttonPanel = new-object System.Windows.Forms.Panel
$buttonPanel.Height = 60
$buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$frmMain.Controls.Add($splitContainer) | Out-Null
$frmMain.Controls.Add($buttonPanel) | Out-Null

newFileExTab $true
newFileExTab $false

$btn = createButton -toolTipText "Open Selected Folder New Tab RIGHT" -iconType ([FontAwesomeIcons.IconType]::FolderO) -eventHandler { newFileExTab $false (rightFirstSelectedPath) } 
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "Open Selected Folder New Tab LEFT" -iconType ([FontAwesomeIcons.IconType]::FolderO) -eventHandler { newFileExTab $true (leftFirstSelectedPath) } 
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "Show PowerShell Console" -iconType ([FontAwesomeIcons.IconType]::Terminal) -eventHandler { showPoShConsole } 
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "Jam Right path to Left" -iconType ([FontAwesomeIcons.IconType]::LongArrowLeft) -eventHandler { (leftShell).Navigate((rightPath)) } 
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "Jam Left path to Right" -iconType ([FontAwesomeIcons.IconType]::LongArrowRight) -eventHandler { (rightShell).Navigate((leftPath)) }
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

# IWebBrowser2 interface which provides Navigate method is implemented by the "Shell Window" object we're keeping arround as "ShDocVw"
# https://msdn.microsoft.com/en-us/library/aa752127(v=vs.85).aspx
$btn = createButton -toolTipText "Swap Left and Right" -iconType ([FontAwesomeIcons.IconType]::Exchange) -eventHandler { $left = leftPath; (leftShell).Navigate((rightPath)); (rightShell).Navigate($left) }
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "(F6) Copy Left to Right" -iconType ([FontAwesomeIcons.IconType]::Copy) -eventHandler { copyLeftToRight $false }
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$btn = createButton -toolTipText "(F5) Move Left to Right" -iconType ([FontAwesomeIcons.IconType]::AngleDoubleRight) -eventHandler { copyLeftToRight $true } 
$btn.Dock = [System.Windows.Forms.DockStyle]::Left
$buttonPanel.Controls.Add($btn)

$frmMain.add_Load({
  #set the intial position of both explorers
  $splitContainer_Resize.Invoke()
})

$frmMain.Add_KeyDown({
  $keyEventArgs = $_
  #[System.Windows.Forms.MessageBox]::Show([string]$keyEventArgs.KeyCode)
  switch ([string]$keyEventArgs.KeyCode) {
    "F5" { copyLeftToRight $true }
    "F6" { copyLeftToRight $false }
  }
})

#nugget: doubleClick in the blank area next to tab headers actually registers on the underlying control vs the TabControl
$splitContainer.Panel1.Add_DoubleClick({ newFileExTab $true })
$splitContainer.Panel2.Add_DoubleClick({ newFileExTab $false })

$frmMain.add_FormClosing({
  $tabContainerLeft.TabPages | %{ closeTab $_ }
})

[System.Windows.Forms.Application]::Run($frmMain)

if ($Error -and $poShConsoleHwnd -ne 0) { showPoShConsole; pause }