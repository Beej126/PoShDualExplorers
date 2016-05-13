#save the compiled Win32 exports wrapper to see if we can spin up faster... in my testing it didn't seem to make a difference
if (Test-path $PSScriptRoot\Win32.dll) { Add-Type -path $PSScriptRoot\Win32.dll }
else {
Add-Type -OutputAssembly $PSScriptRoot\Win32.dll -TypeDefinition @"

using System;
using System.Runtime.InteropServices;
using System.Text;

public class Win32 {

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

    public static readonly UInt32
        WS_POPUP = 0x80000000,
        WS_CHILD = 0x40000000,
        WS_SYSMENU = 524288,
        WS_BORDER = 0x00800000,
        WS_DLGFRAME = 0x00400000,
        WS_CAPTION = WS_BORDER | WS_DLGFRAME,
        WS_THICKFRAME = 262144,
        WS_MINIMIZE = 536870912,
        WS_MAXIMIZEBOX = 65536;

    public static readonly long
        WS_EX_DLGMODALFRAME = 0x1L;


    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindow(String sClassName, String sAppName);

    [DllImport("user32.dll")]
    public static extern int SendMessage(int hWnd, uint Msg, int wParam, int lParam);

    [DllImport("kernel32.dll")]
    public static extern uint GetLastError();

    [DllImport("user32.dll", EntryPoint="SetParent")]
    public static extern IntPtr Win32SetParent(IntPtr hWnd, IntPtr hWndNewParent);

    //from: https://msdn.microsoft.com/en-us/library/windows/desktop/ms633541(v=vs.85).aspx
    //=> "if hWndNewParent is not NULL and the window was previously a child of the desktop, you should clear the WS_POPUP style and set the WS_CHILD style before calling SetParent."
    //from: http://stackoverflow.com/questions/9282284/setwindowlong-getwindowlong-and-32-bit-64-bit-cpus
    public static IntPtr SetParent(IntPtr hWnd, IntPtr hWndNewParent) {
      var result = Win32SetParent(hWnd, hWndNewParent);

      if (hWndNewParent == HWND_TOP) SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) & ~WS_CHILD );
      else SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) | WS_CHILD );

      return result;
    }

    [DllImport("user32.dll")]
    public static extern UInt32 GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, UInt32 dwNewLong);

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

Add-Type -path $PSScriptRoot\Win32.dll
}

