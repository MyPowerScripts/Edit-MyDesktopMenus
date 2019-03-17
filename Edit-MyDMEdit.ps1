#requires -version 3.0
<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER <Parameter-Name>
  .EXAMPLE
  .NOTES
    Script MyDME.ps1 Version 1.0 by MyAdmin on 2/25/2019
    Script Code Generator Version: 4.30.00.00
  .LINK
#>

$ErrorActionPreference = "Stop"

# Comment Out $VerbosePreference Line for Production Deployment
$VerbosePreference = "Continue"

# Comment Out $DebugPreference Line for Production Deployment
$DebugPreference = "Continue"

# Clear Previous Error Messages
$Error.Clear()

[void][System.Reflection.Assembly]::Load("System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Reflection.Assembly]::Load("System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")

#region ******** MyDM Configuration  ********

$MyDMConfig = @{}

# MyDM Script Production Mode
$MyDMConfig.Production = $False

# MyDM Script Configuration
$MyDMConfig.ScriptName = "My Desktop Menus"
$MyDMConfig.ScriptVersion = "0.00.00.00"
$MyDMConfig.ScriptAuthor = "Ken Sweet"

# MyDM Form Control Space
$MyDMConfig.FormSpacer = 4

# MyDM Script Default Font Settings
$MyDMConfig.FontFamily = "Verdana"
$MyDMConfig.FontSize = 10

$MyDMConfig.DefaultIconPath = "$($ENV:windir)\System32\shell32.dll"
$MyDMConfig.DefaultIconIndex = 43
$MyDMConfig.DefaultIconSmall = $Null
$MyDMConfig.DefaultIconLarge = $Null

$MyDMConfig.EnableUser = ($ComputerName -eq [Environment]::MachineName)
$MyDMConfig.EnableSystem = [Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# MyDM Script Auto Exit Settings
$MyDMConfig.AutoExit = 0
$MyDMConfig.AutoExitTic = 60000
$MyDMConfig.AutoExitMax = 0

# MyDM Script Credentials
$MyDMConfig.UseCreds = $False
$MyDMConfig.UserName = "Domain\UserName"
$MyDMConfig.Password = "P@ssw0rd"
$MyDMConfig.Credential = New-Object -TypeName System.Management.Automation.PSCredential($MyDMConfig.UserName, (ConvertTo-SecureString -String $MyDMConfig.Password -AsPlainText -Force))

# MyDM SMTP Configuration
$MyDMConfig.SMTPServer = "smtp.mydomain.local"
$MyDMConfig.SMTPPort = 25

# MyDM SCCM Configuration
$MyDMConfig.SCCMServer = "MySCCM.MyDomain.Local"
$MyDMConfig.SCCMSite = "XYZ"

# Current TimeZone Offset
$MyDMConfig.TZOffset = ([System.TimeZoneInfo]::Local).BaseUtcOffset

# Get Script Path
if ([String]::IsNullOrEmpty($HostInvocation))
{
  $MyDMConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($Script:MyInvocation.MyCommand.Path)
}
else
{
  $MyDMConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($HostInvocation.MyCommand.Path)
}

#endregion ******** MyDM Configuration  ********

#region ******** MyDM Form Custom Colors ********

$MyDMColor = @{}

# Main Form Colors - Mine - Dark
$MyDMColor.BackColor = [System.Drawing.Color]::Black
$MyDMColor.ForeColor = [System.Drawing.Color]::DarkRed

# Default Color for Labels, CheckBoxes, and RadioButtons
$MyDMColor.LabelForeColor = [System.Drawing.Color]::DarkRed

$MyDMColor.ErrorForeColor = [System.Drawing.Color]::Yellow

# Default Color for Title Labels
$MyDMColor.TitleBackColor = [System.Drawing.Color]::DimGray
$MyDMColor.TitleForeColor = [System.Drawing.Color]::Black

# Default Color for GroupBoxes
$MyDMColor.GroupForeColor = [System.Drawing.Color]::DarkRed

# Default Colors for TextBoxes, ComboBoxes, CheckedListBoxes, ListBoxes, ListViews, TreeViews, RichTextBoxes, DateTimePickers, and DataGridViews
$MyDMColor.TextBackColor = [System.Drawing.Color]::LightGray
$MyDMColor.TextForeColor = [System.Drawing.Color]::Black

# Default Color for Buttons
$MyDMColor.ButtonBackColor = [System.Drawing.Color]::DarkGray
$MyDMColor.ButtonForeColor = [System.Drawing.Color]::Black

#endregion ******** MyDM Form Custom Colors ********


#region ******** My Custom Functions ********

#region ********* Show / Hide PowerShell Window *********
$WindowDisplay = @"
using System;
using System.Runtime.InteropServices;

namespace Window
{
  public class Display
  {
    [DllImport("Kernel32.dll")]
    private static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public static bool Hide()
    {
      return ShowWindowAsync(GetConsoleWindow(), 0);
    }

    public static bool Show()
    {
      return ShowWindowAsync(GetConsoleWindow(), 5);
    }
  }
}
"@
Add-Type -TypeDefinition $WindowDisplay -Debug:$False
#endregion ********* Show / Hide PowerShell Window *********

#region ********* Disable Control Close Menu / [X] *********
$ControlBoxMenu = @"
using System;
using System.Runtime.InteropServices;

namespace ControlBox
{
  public class Menu
  {
    const int MF_BYPOSITION = 0x400;

    [DllImport("User32.dll")]
    private static extern int RemoveMenu(IntPtr hMenu, int nPosition, int wFlags);

    [DllImport("User32.dll")]
    private static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);

    [DllImport("User32.dll")]
    private static extern int GetMenuItemCount(IntPtr hWnd);

    public static void DisableFormClose(IntPtr hWnd)
    {
      IntPtr hMenu = GetSystemMenu(hWnd, false);
      int menuItemCount = GetMenuItemCount(hMenu);
      RemoveMenu(hMenu, menuItemCount - 1, MF_BYPOSITION);
    }
  }
}
"@
Add-Type -TypeDefinition $ControlBoxMenu -Debug:$False
#endregion ********* Disable Control Close Menu / [X] *********

#region function Scale-FormControl
function Scale-FormControl()
{
  <#
    .SYNOPSIS
      Scale Form
    .DESCRIPTION
      Scale Form
    .PARAMETER Form
    .PARAMETER Scale
    .EXAMPLE
      Scale-FormControl -Form $Form -$Scale
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [System.Windows.Forms.Form]$Form,
    [Single]$Scale
  )
  Write-Verbose -Message "Enter Function Scale-FormControl"
  Try
  {
    $MyDMConfig.FontSize = $MyDMConfig.FontSize * $Scale
    $Form.Scale($Scale)
    $Form.Font = New-Object -TypeName System.Drawing.Font($Form.Font.FontFamily, ($Form.Font.Size * $Scale), $Form.Font.Style, $Form.Font.Unit)
    ForEach ($Control in $Form.Controls)
    {
      $Control.Font = New-Object -TypeName System.Drawing.Font($Control.Font.FontFamily, ($Control.Font.Size * $Scale), $Control.Font.Style, $Control.Font.Unit)
      if ($Control.Controls.Count)
      {
        Scale-ChildControlFont -Control $Control -Scale $Scale
      }
    }

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Scale-FormControl"
}
#endregion

#region function Scale-ChildControlFont
function Scale-ChildControlFont()
{
  <#
    .SYNOPSIS
      Scale Child Control Font Size
    .DESCRIPTION
      Scale Child Control Font Size
    .PARAMETER Control
    .PARAMETER Scale
    .EXAMPLE
      Scale-ChildControlFont -Control $Control -Scale $Scale
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [Object]$Control,
    [Single]$Scale
  )
  Write-Verbose -Message "Enter Function Scale-ChildControlFont"
  Try
  {
    ForEach ($ChildControl in $Control.Controls)
    {
      $ChildControl.Font = New-Object -TypeName System.Drawing.Font($ChildControl.Font.FontFamily, ($ChildControl.Font.Size * $Scale), $ChildControl.Font.Style, $ChildControl.Font.Unit)
      if ($ChildControl.Controls.Count)
      {
        Scale-ChildControlFont -Control $ChildControl -Scale $Scale
      }
    }

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Scale-ChildControlFont"
}
#endregion function Scale-FormContro

#region function Write-MyLogFile
function Write-MyLogFile()
{
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER LogFile
    .PARAMETER Severity
    .PARAMETER Message
    .PARAMETER Context
    .PARAMETER Thread
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Message "This is My Info Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Info" -Message "This is My Info Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Warning" -Message "This is My Warning Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFile $LogFile -Severity "Error" -Message "This is My Error Log File Message"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [ValidateScript({ [System.IO.Directory]::Exists([System.IO.Path]::GetDirectoryName($PSItem)) })]
    [String]$LogFile,
    [ValidateSet("Info", "Warning", "Error")]
    [String]$Severity = "Info",
    [parameter(Mandatory = $True)]
    [String]$Message,
    [String]$Context = "",
    [Int]$Thread = $PID
  )
  Write-Verbose -Message "Enter Function Write-MyLogFile"
  Try
  {
    $TempDate = [DateTime]::Now
    $TempStack = @(Get-PSCallStack)
    Switch ($Severity)
    {
      "Info" { $TempSeverity = 1; Break }
      "Warning" { $TempSeverity = 2; Break }
      "Error" { $TempSeverity = 3; Break }
    }
    Add-Content -Path $LogFile -Value ("<![LOG[{0}]LOG]!><time=`"{1}`" date=`"{2}`" component=`"{3}`" context=`"{4}`" type=`"{5}`" thread=`"{6}`" file=`"{7}`">" -f $Message, $($TempDate.ToString("HH:mm:ss.fff+000")), $($TempDate.ToString("MM-dd-yyyy")), $TempStack[1].Command, $Context, $TempSeverity, $Thread, "$([System.IO.Path]::GetFileName($TempStack[1].ScriptName)):$($TempStack[1].ScriptLineNumber)-$($TempStack.Count - 3)") -Encoding "Ascii"

    $TempDate = $Null
    $TempStack = $Null
    $TempSeverity = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Write-MyLogFile"
}
#endregion function Write-MyLogFile

#region function Get-MyFontData
function Get-MyFontData()
{
  <#
    .SYNOPSIS
      Get New Font Size Based on Current Dpi
    .DESCRIPTION
      Get New Font Size Based on Current Dpi
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER TextString
    .EXAMPLE
      $FontData = Get-MyFontData
    .EXAMPLE
      $FontData = Get-MyFontData -FontFamily "Verdana" -FontSize 10
    .EXAMPLE
      $FontData = Get-MyFontData -FontFamily "Verdana" -FontSize 10 -TextString "Sample Text"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [System.Drawing.FontFamily]$FontFamily = $MyDMConfig.FontFamily,
    [Single]$FontSize = $MyDMConfig.FontSize,
    [String]$TextString = "The quick brown fox jumped over the lazy dogs back"
  )
  Write-Verbose -Message "Enter Function Get-MyFontData"
  Try
  {
    $Graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $Ratio = 96 / $Graphics.DpiX
    $MeasureString = $Graphics.MeasureString($TextString, (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)))
    [PSCustomObject]@{
      "Ratio" = $Ratio;
      "FontSize" = ($FontSize * $Ratio);
      "Width" = [Math]::Floor($MeasureString.Width / $TextString.Length);
      "Height" = [Math]::Ceiling($MeasureString.Height);
      "DpiX" = $Graphics.DpiX;
      "DpiY" = $Graphics.DpiY;
      "Bold" = New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
      "Regular" = New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
    }
    $MeasureString = $Null
    $Graphics.Dispose()
    $Graphics = $Null
    $Ratio = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Get-MyFontData"
}
#endregion function Get-MyFontData

# MyDME Script Default Font Settings
$MyDMConfig.FontData = Get-MyFontData
$MyDMConfig.FontSize = $MyDMConfig.FontData.FontSize

#endregion ******** My Custom Functions ********



#region ******** MyDME Form Custom Colors ********

$MyDMEConfig = $MyDMConfig

$MyDMEColor = @{
}


$ReturnVal01Text = ""
$ReturnVal02Text = ""




#endregion ******** MyDME Form Custom Colors ********


#region ******** $Noneico ********
$Noneico = @"
AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAkAAAAPAAAAFgAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAFgAA
ABAAAAALAAAAAAAAAAQAAAANAAAARAAAAE4AAABRAAAAUQAAAFEAAABRAAAAUQAAAFEAAABRAAAAUQAAAE4AAABIAAAAEAAAAAAAAAAF8alk//GrZ//xrGn/8q5s//KubP/yrm3/8q5t//Kubf/yrmz/8axp//Gr
Z//xqWT/AAAATgAAABYAAAAAAAAABvGoYf/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/7Ozs/+zs7P/s7Oz/8ahh/wAAAFEAAAAYAAAAAAAAAAbwpl7/7e3t/+3t7f/t7e3/7e3t/+3t7f/t7e3/7e3t/+3t
7f/t7e3/7e3t//CmXv8AAABRAAAAGAAAAAAAAAAG8KNZ/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//wo1n/AAAAUQAAABgAAAAAAAAABvChVP/r6+v/6+vr/+vr6//r6+v/6+vr/+vr
6//r6+v/6+vr/+vr6//q6ur/8KFU/wAAAFEAAAAYAAAAAAAAAAbwoVT/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/6urq//ChVP8AAABRAAAAGAAAAAAAAAAG8KNZ/+7u7v/u7u7/7u7u/+7u
7v/u7u7/7u7u/+7u7v/u7u7/7u7u/+zs7P/wo1n/AAAAUQAAABgAAAAAAAAABvCnYP/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/t7e3/8Kdg/wAAAFEAAAAYAAAAAAAAAAbwp2D/8PDw//Dw
8P/w8PD/8PDw//Dw8P/w8PD/8PDw//Dw8P/w8PD/7e3t//CnYP8AAABQAAAAFwAAAAAAAAAG8Kto//Hx8f/x8fH/8fHx//Hx8f/x8fH/8fHx//Hx8f/x8fH/8fHx//Dw8P/wq2j/AAAASgAAABEAAAAAAAAABvGx
cv/z8/P/9PT0//T09P/09PT/9PT0//T09P/09PT/8bFy//Gxcv/xsXL/8bFy/wAAABQAAAALAAAAAAAAAAXyt33/9vb2//b29v/29vb/9vb2//b29v/29vb/9vb2//O3fv/34M7/8rd9/wAAABQAAAALAAAABQAA
AAAAAAAE9L2J//n5+f/6+vr/+vr6//r6+v/6+vr/+vr6//r6+v/0von/9L6J/wAAABQAAAALAAAABAAAAAEAAAAAAAAAA/XFlv/1xZb/9cWW//XFlv/1xZb/9cWW//XFlv/1xZb/9cWW/wAAABEAAAALAAAABQAA
AAEAAAAAgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgACsQYAArEGAAKxBgAGsQQ==
"@
#endregion

#region function Show-MyDMEditDialog
function Show-MyDMEditDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER Value
      Value Command Line Parameter
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Show-MyDMEditDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "MenuCommand")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "DesktopMenu")]
    [Switch]$DesktopMenu,
    [parameter(Mandatory = $True, ParameterSetName = "SubMenu")]
    [Switch]$SubMenu,
    [String]$ReturnVal01Text,
    [String]$ReturnVal02Text = "",
    [String]$IconPath = $MyDMConfig.DefaultIconPath,
    [Int]$Index = $MyDMConfig.DefaultIconIndex,
    [System.Drawing.Icon]$IconSmall,
    [System.Drawing.Icon]$IconLarge,
    [System.Windows.Forms.Form]$Owner = $MyDMForm,
    [Int]$FormSpacer = $MyDMConfig.FormSpacer,
    [System.Drawing.Font]$FontRegular = $MyDMConfig.FontData.Regular,
    [System.Drawing.Font]$FontBold = $MyDMConfig.FontData.Bold,
    [System.Drawing.Color]$BackColor = $MyDMColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMColor.ForeColor,
    [System.Drawing.Color]$LabelForeColor = $MyDMColor.LabelForeColor,
    [System.Drawing.Color]$ErrorForeColor = $MyDMColor.ErrorForeColor,
    [System.Drawing.Color]$TitleBackColor = $MyDMColor.TitleBackColor,
    [System.Drawing.Color]$TitleForeColor = $MyDMColor.TitleForeColor,
    [System.Drawing.Color]$GroupForeColor = $MyDMColor.GroupForeColor,
    [System.Drawing.Color]$TextBackColor = $MyDMColor.TextBackColor,
    [System.Drawing.Color]$TextForeColor = $MyDMColor.TextForeColor,
    [System.Drawing.Color]$ButtonBackColor = $MyDMColor.ButtonBackColor,
    [System.Drawing.Color]$ButtonForeColor = $MyDMColor.ButtonForeColor
  )
  Write-Verbose -Message "Enter Function Show-MyDMEditDialog"
  
  Switch ($PSCmdlet.ParametersetName)
  {
    "DesktopMenu"
    {
      $TitleName = "Desktop Menu"
      $ReturnName = "Desktop Menu"
      $ReturnVals = 2
      $ReturnVal01Label = "Menu GUID"
      $ReturnVal01ReadOnly = $True
      if ([String]::IsNullOrEmpty($ReturnVal01Text))
      {
        $ReturnVal01Text = ([System.Guid]::NewGuid()).Guid
      }
      $ReturnVal02Label = "Menu Name"
      $ReturnVal02ReadOnly = $False
      Break
    }
    "SubMenu"
    {
      $TitleName = "Sub Menu"
      $ReturnName = "Desktop Menu Sub Menu"
      $ReturnVals = 1
      $ReturnVal01Label = "Sub Menu Name"
      $ReturnVal01ReadOnly = $False
      Break
    }
    "MenuCommand"
    {
      $TitleName = "Menu Command"
      $ReturnName = "Desktop Menu Command"
      $ReturnVals = 2
      $ReturnVal01Label = "Command Name"
      $ReturnVal01ReadOnly = $False
      $ReturnVal02Label = "Command Line"
      $ReturnVal02ReadOnly = $False
      Break
    }
  }
  
  $MyDMEFormComponents = New-Object -TypeName System.ComponentModel.Container

  #region $MyDMEToolTip = System.Windows.Forms.ToolTip
  Write-Verbose -Message "Creating Form Control `$MyDMEToolTip"
  $MyDMEToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMEFormComponents)
  #$MyDMEToolTip.Active = $True
  #$MyDMEToolTip.AutomaticDelay = 500
  #$MyDMEToolTip.AutoPopDelay = 5000
  #$MyDMEToolTip.BackColor = [System.Drawing.SystemColors]::Info
  #$MyDMEToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
  #$MyDMEToolTip.InitialDelay = 500
  #$MyDMEToolTip.IsBalloon = $False
  #$MyDMEToolTip.OwnerDraw = $False
  #$MyDMEToolTip.ReshowDelay = 100
  #$MyDMEToolTip.ShowAlways = $False
  #$MyDMEToolTip.Site = System.ComponentModel.ISite
  #$MyDMEToolTip.StripAmpersands = $False
  #$MyDMEToolTip.Tag = $Null
  #$MyDMEToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
  $MyDMEToolTip.ToolTipTitle = "$($MyDMConfig.ScriptName) - $($MyDMConfig.ScriptVersion)"
  #$MyDMEToolTip.UseAnimation = $True
  #$MyDMEToolTip.UseFading = $True
  #endregion
  #$MyDMEToolTip.SetToolTip($FormControl, "Form Control Help")

  #region $MyDMEForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDMEForm"
  $MyDMEForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDMEForm.BackColor = $BackColor
  #$MyDMEForm.CancelButton = System.Windows.Forms.Button
  #$MyDMEForm.ControlBox = $True
  $MyDMEForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $MyDMEForm.Font = $FontRegular
  $MyDMEForm.ForeColor = $ForeColor
  $MyDMEForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
  $MyDMEForm.KeyPreview = $True
  $MyDMEForm.MaximizeBox = $False
  #$MyDMEForm.MaximumSize = New-Object -TypeName System.Drawing.Size(0, 0)
  $MyDMEForm.MinimizeBox = $False
  #$MyDMEForm.MinimumSize = New-Object -TypeName System.Drawing.Size(0, 0)
  $MyDMEForm.Name = "MyDMEForm"
  $MyDMEForm.Owner = $Owner
  $MyDMEForm.ShowIcon = $False
  $MyDMEForm.ShowInTaskbar = $False
  #$MyDMEForm.Size = New-Object -TypeName System.Drawing.Size(300, 300)
  #$MyDMEForm.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Auto
  $MyDMEForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  #$MyDMEForm.TabIndex = 0
  #$MyDMEForm.TabStop = $True
  $MyDMEForm.Tag = (-not $MyDMConfig.Production)
  $MyDMEForm.Text = $TitleName
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEForm, "Help for Control $($MyDMEForm.Name)")

  #region function Start-MyDMEFormClosing
  function Start-MyDMEFormClosing()
  {
    <#
      .SYNOPSIS
        Closing event for the MyDMEForm Control
      .DESCRIPTION
        Closing event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormClosing -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Closing Event for `$MyDMEForm"
    Try
    {
      $MyDMConfig.AutoExit = 0
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      # Show Console Window
      $Script:VerbosePreference = "Continue"
      $Script:DebugPreference = "Continue"
      [Void][Window.Display]::Show()
      $MyDMEForm.Tag = $True
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Closing Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormClosing
  $MyDMEForm.add_Closing({Start-MyDMEFormClosing -Sender $This -EventArg $PSItem})

  #region function Start-MyDMEFormKeyDown
  function Start-MyDMEFormKeyDown()
  {
    <#
      .SYNOPSIS
        KeyDown event for the MyDMEForm Control
      .DESCRIPTION
        KeyDown event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormKeyDown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MyDMEForm"
    Try
    {
      $MyDMConfig.AutoExit = 0
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      if ($EventArg.Control -and $EventArg.Alt -and $EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F10)
      {
        if ($MyDMEForm.Tag)
        {
          # Hide Console Window
          $Script:VerbosePreference = "SilentlyContinue"
          $Script:DebugPreference = "SilentlyContinue"
          [Void][Window.Display]::Hide()
          $MyDMEForm.Tag = $False
        }
        else
        {
          # Show Console Window
          $Script:VerbosePreference = "Continue"
          $Script:DebugPreference = "Continue"
          [Void][Window.Display]::Show()
          [System.Console]::Title = "DEBUG: $($MyDMConfig.ScriptName)"
          $MyDMEForm.Tag = $True
        }
        $MyDMEForm.Activate()
        $MyDMEForm.Select()
      }
      elseif ($EventArg.KeyCode -eq [System.Windows.Forms.Keys]::F1)
      {
        $MyDMEToolTip.Active = (-not $MyDMEToolTip.Active)
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit KeyDown Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormKeyDown
  $MyDMEForm.add_KeyDown({Start-MyDMEFormKeyDown -Sender $This -EventArg $PSItem})

  #region function Start-MyDMEFormLoad
  function Start-MyDMEFormLoad()
  {
    <#
      .SYNOPSIS
        Load event for the MyDMEForm Control
      .DESCRIPTION
        Load event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormLoad -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Load Event for `$MyDMEForm"
    Try
    {
      $MyDMConfig.AutoExit = 0
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor

      $Screen = ([System.Windows.Forms.Screen]::FromControl($Sender)).WorkingArea
      $Sender.Left = [Math]::Floor(($Screen.Width - $Sender.Width) / 2)
      $Sender.Top = [Math]::Floor(($Screen.Height - $Sender.Height) / 2)

      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Load Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormLoad
  $MyDMEForm.add_Load({Start-MyDMEFormLoad -Sender $This -EventArg $PSItem})

  #region function Start-MyDMEFormShown
  function Start-MyDMEFormShown()
  {
    <#
      .SYNOPSIS
        Shown event for the MyDMEForm Control
      .DESCRIPTION
        Shown event for the MyDMEForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEFormShown -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Shown Event for `$MyDMEForm"
    Try
    {
      $MyDMConfig.AutoExit = 0
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Shown Event for `$MyDMEForm"
  }
  #endregion function Start-MyDMEFormShown
  $MyDMEForm.add_Shown({Start-MyDMEFormShown -Sender $This -EventArg $PSItem})

  #region ******** $MyDMEForm Controls ********

  #region $MyDMEReturnGroupBox = System.Windows.Forms.GroupBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnGroupBox"
  $MyDMEReturnGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
  # Location of First Control New-Object -TypeName System.Drawing.Point($FormSpacer, $FontHeight)
  $MyDMEForm.Controls.Add($MyDMEReturnGroupBox)
  #$MyDMEReturnGroupBox.BackColor = $BackColor
  #$MyDMEReturnGroupBox.Enabled = $True
  $MyDMEReturnGroupBox.Font = $FontRegular
  $MyDMEReturnGroupBox.ForeColor = $GroupForeColor
  $MyDMEReturnGroupBox.Location = New-Object -TypeName System.Drawing.Point($FormSpacer, $FormSpacer)
  $MyDMEReturnGroupBox.Name = "MyDMEReturnGroupBox"
  #$MyDMEReturnGroupBox.TabIndex = 0
  #$MyDMEReturnGroupBox.TabStop = $False
  #$MyDMEReturnGroupBox.Tag = $Null
  $MyDMEReturnGroupBox.Text = $ReturnName
  #endregion

  #region ******** $MyDMEReturnGroupBox Controls ********

  #region $MyDMEReturnIconPictureBox = System.Windows.Forms.PictureBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnIconPictureBox"
  $MyDMEReturnIconPictureBox = New-Object -TypeName System.Windows.Forms.PictureBox
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnIconPictureBox)
  #$MyDMEReturnIconPictureBox.AutoSize = $False
  $MyDMEReturnIconPictureBox.BackColor = $MyDMColor.TextBackColor
  #$MyDMEReturnIconPictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  #$MyDMEReturnIconPictureBox.ForeColor = [System.Drawing.SystemColors]::ControlText
  $MyDMEReturnIconPictureBox.Image = $IconLarge
  $MyDMEReturnIconPictureBox.Location = New-Object -TypeName System.Drawing.Point(($FormSpacer * 2), $MyDMConfig.FontData.Height)
  $MyDMEReturnIconPictureBox.Name = "MyDMEReturnIconPictureBox"
  $MyDMEReturnIconPictureBox.Size = New-Object -TypeName System.Drawing.Size(48, 48)
  #$MyDMEReturnIconPictureBox.TabIndex = 0
  #$MyDMEReturnIconPictureBox.TabStop = $False
  $MyDMEReturnIconPictureBox.Tag = @{ "DialogResult" = [System.Windows.Forms.DialogResult]::OK;"ReturnVal01Text" = $ReturnVal01Text; "ReturnVal02Text" = $ReturnVal02Text; "IconPath" = $IconPath; "Index" = $Index; "IconSmall" = $IconSmall; "IconLarge" = $IconLarge}
  $MyDMEReturnIconPictureBox.Text = "MyDMEReturnIconPictureBox"
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEReturnIconPictureBox, "Help for Control $($MyDMEReturnIconPictureBox.Name)")

  #region function Start-MyDMEReturnIconPictureBoxDoubleClick
  function Start-MyDMEReturnIconPictureBoxDoubleClick()
  {
    <#
      .SYNOPSIS
        DoubleClick event for the MyDMEReturnIconPictureBox Control
      .DESCRIPTION
        DoubleClick event for the MyDMEReturnIconPictureBox Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEReturnIconPictureBoxDoubleClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter DoubleClick Event for `$MyDMEReturnIconPictureBox"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit DoubleClick Event for `$MyDMEReturnIconPictureBox"
  }
  #endregion function Start-MyDMEReturnIconPictureBoxDoubleClick
  $MyDMEReturnIconPictureBox.add_DoubleClick({Start-MyDMEReturnIconPictureBoxDoubleClick -Sender $This -EventArg $PSItem})

  #region $MyDMEReturnVal01Label = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal01Label"
  $MyDMEReturnVal01Label = New-Object -TypeName System.Windows.Forms.Label
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal01Label)
  $MyDMEReturnVal01Label.BackColor = $BackColor
  $MyDMEReturnVal01Label.Font = $FontRegular
  $MyDMEReturnVal01Label.ForeColor = $LabelForeColor
  $MyDMEReturnVal01Label.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnIconPictureBox.Right + $FormSpacer), $MyDMEReturnIconPictureBox.Top)
  $MyDMEReturnVal01Label.Name = "MyDMEReturnVal01Label"
  $MyDMEReturnVal01Label.Text = "$($ReturnVal01Label):"
  $MyDMEReturnVal01Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
  #endregion
  $MyDMEReturnVal01Label.Size = $MyDMEReturnVal01Label.PreferredSize

  if ($ReturnVals -eq 2)
  {
    #region $MyDMEReturnVal02Label = System.Windows.Forms.Label
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal02Label"
    $MyDMEReturnVal02Label = New-Object -TypeName System.Windows.Forms.Label
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal02Label)
    $MyDMEReturnVal02Label.BackColor = $BackColor
    $MyDMEReturnVal02Label.Font = $FontRegular
    $MyDMEReturnVal02Label.ForeColor = $LabelForeColor
    $MyDMEReturnVal02Label.Location = New-Object -TypeName System.Drawing.Point($MyDMEReturnVal01Label.Left, ($MyDMEReturnVal01Label.Bottom + ($FormSpacer * 2)))
    $MyDMEReturnVal02Label.Name = "MyDMEReturnVal02Label"
    $MyDMEReturnVal02Label.Text = "$($ReturnVal02Label):"
    $MyDMEReturnVal02Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    #endregion
    $MyDMEReturnVal02Label.Size = $MyDMEReturnVal02Label.PreferredSize
    $TempWidth = [Math]::Max($MyDMEReturnVal01Label.Size.Width, $MyDMEReturnVal02Label.Size.Width)
    $MyDMEReturnVal01Label.Width = $TempWidth
    $MyDMEReturnVal02Label.Width = $TempWidth
    
    $MyDMEReturnIconPictureBox.Top = $MyDMEReturnIconPictureBox.Top + [Math]::Floor(($MyDMEReturnVal02Label.Bottom - $MyDMEReturnIconPictureBox.Bottom) / 2)
    
    $TempBottom = [Math]::Max($MyDMEReturnVal02Label.Bottom, $MyDMEReturnIconPictureBox.Bottom)
    
    #region $MyDMEReturnVal02TextBox = System.Windows.Forms.TextBox
    Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal02TextBox"
    $MyDMEReturnVal02TextBox = New-Object -TypeName System.Windows.Forms.TextBox
    $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal02TextBox)
    $MyDMEReturnVal02TextBox.BackColor = $TextBackColor
    $MyDMEReturnVal02TextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $MyDMEReturnVal02TextBox.Font = $FontRegular
    $MyDMEReturnVal02TextBox.ForeColor = $TextForeColor
    $MyDMEReturnVal02TextBox.Height = $MyDMEReturnVal02Label.Height
    $MyDMEReturnVal02TextBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnVal02Label.Right + $FormSpacer), $MyDMEReturnVal02Label.Top)
    $MyDMEReturnVal02TextBox.MaxLength = 50
    $MyDMEReturnVal02TextBox.Name = "MyDMEReturnVal02TextBox"
    $MyDMEReturnVal02TextBox.ReadOnly = $ReturnVal02ReadOnly
    #$MyDMEReturnVal02TextBox.TabIndex = 0
    #$MyDMEReturnVal02TextBox.TabStop = $True
    #$MyDMEReturnVal02TextBox.Tag = $Null
    $MyDMEReturnVal02TextBox.Text = $ReturnVal02Text
    $MyDMEReturnVal02TextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
    $MyDMEReturnVal02TextBox.Width = $MyDMEReturnIconPictureBox.Width * 6
    #endregion
    $MyDMEToolTip.SetToolTip($MyDMEReturnVal02TextBox, "Help for Control $($MyDMEReturnVal02TextBox.Name)")
  }
  else
  {
    $MyDMEReturnVal01Label.Top = $MyDMEReturnVal01Label.Top + [Math]::Floor(($MyDMEReturnIconPictureBox.Bottom - $MyDMEReturnVal01Label.Bottom) / 2)
    $TempBottom = [Math]::Max($MyDMEReturnVal01Label.Bottom, $MyDMEReturnIconPictureBox.Bottom)
  }

  #region $MyDMEReturnVal01TextBox = System.Windows.Forms.TextBox
  Write-Verbose -Message "Creating Form Control `$MyDMEReturnVal01TextBox"
  $MyDMEReturnVal01TextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MyDMEReturnGroupBox.Controls.Add($MyDMEReturnVal01TextBox)
  $MyDMEReturnVal01TextBox.BackColor = $TextBackColor
  $MyDMEReturnVal01TextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $MyDMEReturnVal01TextBox.Font = $FontRegular
  $MyDMEReturnVal01TextBox.ForeColor = $TextForeColor
  $MyDMEReturnVal01TextBox.Height = $MyDMEReturnVal01Label.Height
  $MyDMEReturnVal01TextBox.Location = New-Object -TypeName System.Drawing.Point(($MyDMEReturnVal01Label.Right + $FormSpacer), $MyDMEReturnVal01Label.Top)
  $MyDMEReturnVal01TextBox.MaxLength = 50
  $MyDMEReturnVal01TextBox.Name = "MyDMEReturnVal01TextBox"
  $MyDMEReturnVal01TextBox.ReadOnly = $ReturnVal01ReadOnly
  #$MyDMEReturnVal01TextBox.TabIndex = 0
  #$MyDMEReturnVal01TextBox.TabStop = $True
  #$MyDMEReturnVal01TextBox.Tag = $Null
  $MyDMEReturnVal01TextBox.Text = $ReturnVal01Text
  $MyDMEReturnVal01TextBox.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Left
  $MyDMEReturnVal01TextBox.Width = $MyDMEReturnIconPictureBox.Width * 6
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEReturnVal01TextBox, "Help for Control $($MyDMEReturnVal01TextBox.Name)")

  $MyDMEReturnGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMEReturnGroupBox.Controls[$MyDMEReturnGroupBox.Controls.Count - 1]).Right + ($FormSpacer * 2)), ($TempBottom + ($FormSpacer * 2)))

  #endregion ******** $MyDMEReturnGroupBox Controls ********

  #region $MyDMEOKButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMEOKButton"
  $MyDMEOKButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMEForm.Controls.Add($MyDMEOKButton)
  # Evenly Space Buttons - Move Size to after Text
  $NumButtons = 2
  $TempSpace = [Math]::Floor($MyDMEReturnGroupBox.Width - ($FormSpacer * ($NumButtons + 2)))
  $TempWidth = [Math]::Floor($TempSpace / $NumButtons)
  $TempMod = $TempSpace % $NumButtons
  $MyDMEOKButton.AutoSize = $True
  $MyDMEOKButton.BackColor = $ButtonBackColor
  #$MyDMEOKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $MyDMEOKButton.Font = $FontBold
  $MyDMEOKButton.ForeColor = $ButtonForeColor
  #$MyDMEOKButton.Image = [System.Drawing.Image]([System.Convert]::FromBase64String($ImageFile))
  #$MyDMEOKButton.ImageAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMEOKButton.Location = New-Object -TypeName System.Drawing.Point(($FormSpacer * 2), ($MyDMEReturnGroupBox.Bottom + ($FormSpacer * 2)))
  $MyDMEOKButton.Name = "MyDMEOKButton"
  #$MyDMEOKButton.Size = New-Object -TypeName System.Drawing.Size(75, 23)
  #$MyDMEOKButton.TabIndex = 0
  #$MyDMEOKButton.TabStop = $True
  #$MyDMEOKButton.Tag = $Null
  $MyDMEOKButton.Text = "OK"
  $MyDMEOKButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMEOKButton.Width = $TempWidth
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMEOKButton, "Help for Control $($MyDMEOKButton.Name)")

  #region function Start-MyDMEOKButtonClick
  function Start-MyDMEOKButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMEOKButton Control
      .DESCRIPTION
        Click event for the MyDMEOKButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMEOKButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMEOKButton"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      
      $NoError = $True
      
      if ([String]::IsNullOrEmpty($MyDMEReturnVal01TextBox.Text))
      {
        $MyDMEReturnVal01Label.ForeColor = $ErrorForeColor
        $NoError = $False
      }
      else
      {
        $MyDMEReturnVal01Label.ForeColor = $ForeColor
        $MyDMEReturnIconPictureBox.Tag.ReturnVal01Text = $MyDMEReturnVal01TextBox.Text
      }
      if ($ReturnVals -eq 2)
      {
        if ([String]::IsNullOrEmpty($MyDMEReturnVal02TextBox.Text))
        {
          $MyDMEReturnVal02Label.ForeColor = $ErrorForeColor
          $NoError = $False
        }
        else
        {
          $MyDMEReturnVal02Label.ForeColor = $ForeColor
          $MyDMEReturnIconPictureBox.Tag.ReturnVal02Text = $MyDMEReturnVal02TextBox.Text
        }
      }
      
      if ($NoError)
      {
        $MyDMEForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $MyDMEForm.Close()
      }
      else
      {
        [Void]([System.Windows.Forms.MessageBox]::Show($MyDMEForm, "Error with entered $TitleName values.", "Error: $TitleName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
      }
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMEOKButton"
  }
  #endregion function Start-MyDMEOKButtonClick
  $MyDMEOKButton.add_Click({ Start-MyDMEOKButtonClick -Sender $This -EventArg $PSItem })

  #region $MyDMECancelButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDMECancelButton"
  $MyDMECancelButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDMEForm.Controls.Add($MyDMECancelButton)
  $MyDMECancelButton.AutoSize = $True
  $MyDMECancelButton.BackColor = $ButtonBackColor
  $MyDMECancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDMECancelButton.Font = $FontBold
  $MyDMECancelButton.ForeColor = $ButtonForeColor
  #$MyDMECancelButton.Image = [System.Drawing.Image]([System.Convert]::FromBase64String($ImageFile))
  #$MyDMECancelButton.ImageAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMECancelButton.Location = New-Object -TypeName System.Drawing.Point(($MyDMEOKButton.Right + $TempMod + ($FormSpacer * 2)), $MyDMEOKButton.Top)
  $MyDMECancelButton.Name = "MyDMECancelButton"
  #$MyDMECancelButton.Size = New-Object -TypeName System.Drawing.Size(75, 23)
  #$MyDMECancelButton.TabIndex = 0
  #$MyDMECancelButton.TabStop = $True
  #$MyDMECancelButton.Tag = $Null
  $MyDMECancelButton.Text = "Cancel"
  $MyDMECancelButton.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  $MyDMECancelButton.Width = $TempWidth
  #endregion
  $MyDMEToolTip.SetToolTip($MyDMECancelButton, "Help for Control $($MyDMECancelButton.Name)")

  #region function Start-MyDMECancelButtonClick
  function Start-MyDMECancelButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMECancelButton Control
      .DESCRIPTION
        Click event for the MyDMECancelButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMECancelButtonClick -Sender $Sender -EventArg $EventArg
      .NOTES
        Original Function By Ken Sweet
      .LINK
    #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter Click Event for `$MyDMECancelButton"
    Try
    {
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      #$MyDMEForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMECancelButton"
  }
  #endregion function Start-MyDMECancelButtonClick
  #$MyDMECancelButton.add_Click({ Start-MyDMECancelButtonClick -Sender $This -EventArg $PSItem })

  $MyDMEForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDMEReturnGroupBox.Right + $FormSpacer), ($($MyDMEForm.Controls[$MyDMEForm.Controls.Count - 1]).Bottom + $FormSpacer))
  
  #endregion ******** $MyDMEForm Controls ********
  
  $MyDMEReturnIconPictureBox.Tag.DialogResult = $MyDMEForm.ShowDialog()
  [PSCustomObject]($MyDMEReturnIconPictureBox.Tag)
  
  Write-Verbose -Message "Exit Function Show-MyDMEditDialog"
}
#endregion

Show-MyDMEditDialog -DesktopMenu
Show-MyDMEditDialog -SubMenu
Show-MyDMEditDialog

#[System.Windows.Forms.Application]::EnableVisualStyles()
#[System.Windows.Forms.Application]::Run($MyDMEForm)

if ($MyDMConfig.Production)
{
  [Environment]::Exit(0)
}








