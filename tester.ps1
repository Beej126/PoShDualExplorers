Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
& $PSScriptRoot\FontAwesome.ps1 # handy wrapper for FontAwesome as a .Net class, from here: https://github.com/microvb/FontAwesome-For-WinForms-CSharp

<#
function createButton {
  param( [string]$toolTipText, [string]$caption, [string]$faType, [scriptblock]$eventHandler, [bool]$return = $false )

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = [System.Windows.Forms.DockStyle]::Left
    $panel.Width = 60
    $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $btn = New-Object System.Windows.Forms.Button
    $btn.Dock = [System.Windows.Forms.DockStyle]::Top
    $btn.Height = 60
    $btn.Text = $faType
    $btn.Add_Click($eventHandler)

    $toolTip = New-Object System.Windows.Forms.ToolTip
    $toolTip.SetToolTip($btn, $toolTipText)
    $panel.Controls.Add($btn)

    $label1 = New-Object System.Windows.Forms.Label
    $label1.Text = $caption
    $label1.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $label1.Dock = [System.Windows.Forms.DockStyle]::Top
    $label1.Height = 17
    $panel.Controls.Add($label1)

    #$btn.Font = $font

    $buttonPanel.Controls.Add($panel)

    if ($return) { return $btn }
}
#>

#$font = [FontAwesome]::Font

$frmMain = New-Object System.Windows.Forms.Form
$frmMain.Text = "DuEx"

$buttonPanel = new-object System.Windows.Forms.Panel
$buttonPanel.Height = 80
$buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$frmMain.Controls.Add($buttonPanel) | Out-Null
<#
createButton -toolTipText "move left to right" -caption "Move" -faType ([Fa]::toggleOn) -eventHandler { [System.Windows.Forms.MessageBox]::Show("bingo!!") }
createButton -toolTipText "move left to right" -caption "Move" -faType ([Fa]::toggleOn) -eventHandler { [System.Windows.Forms.MessageBox]::Show("bingo!!") }
#>
$faBtn = New-Object FontAwesomeButton("move left to right", "Move", [Fa]::ToggleOff, $buttonPanel);
$faBtn.Button.Add_Click({ [System.Windows.Forms.MessageBox]::Show("bingo!!") } )
$faBtn = New-Object FontAwesomeButton("move left to right", "Move", [Fa]::ToggleOff, $buttonPanel);
$faBtn.Button.Add_Click({ [System.Windows.Forms.MessageBox]::Show("bingo!!") } )


[System.Windows.Forms.Application]::Run($frmMain)
