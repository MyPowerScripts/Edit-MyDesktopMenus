#requires -version 3.0
<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER <Parameter-Name>
  .EXAMPLE
  .NOTES
    Script MyDMH.ps1 Version 1.0 by MyAdmin on 3/8/2019
    Script Code Generator Version: 4.40.00.00
  .LINK
#>
#[CmdletBinding()]
#param (
#)

$ErrorActionPreference = "Stop"

# Comment Out $VerbosePreference Line for Production Deployment
$VerbosePreference = "Continue"

# Comment Out $DebugPreference Line for Production Deployment
$DebugPreference = "Continue"

# Clear Previous Error Messages
$Error.Clear()

[void][System.Reflection.Assembly]::Load("System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
[void][System.Reflection.Assembly]::Load("System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")

#region ******** MyDMH Configuration  ********

$MyDMHConfig = @{}

# MyDMH Script Production Mode
$MyDMHConfig.Production = $False

# MyDMH Script Configuration
$MyDMHConfig.ScriptName = "MyDMH.ps1"
$MyDMHConfig.ScriptVersion = "0.00.00.00"
$MyDMHConfig.ScriptAuthor = "MyAdmin"

# MyDMH Form Control Space
$MyDMHConfig.FormSpacer = 4

# MyDMH Script Default Font Settings
$MyDMHConfig.FontFamily = "Tahoma"
$MyDMHConfig.FontSize = 10

# MyDMH Script Auto Exit Settings
$MyDMHConfig.AutoExit = 0
$MyDMHConfig.AutoExitTic = 60000
$MyDMHConfig.AutoExitMax = 60

$MyDMHConfig.IsLocalAdmin = [Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$MyDMHConfig.IsConnected = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))

# MyDMH Script Credentials
$MyDMHConfig.UseCreds = $False
$MyDMHConfig.UserName = "Domain\UserName"
$MyDMHConfig.Password = "P@ssw0rd"
$MyDMHConfig.Credential = New-Object -TypeName System.Management.Automation.PSCredential($MyDMHConfig.UserName, (ConvertTo-SecureString -String $MyDMHConfig.Password -AsPlainText -Force))

# MyDMH SMTP Configuration
$MyDMHConfig.SMTPServer = "smtp.mydomain.local"
$MyDMHConfig.SMTPPort = 25

# MyDMH SCCM Configuration
$MyDMHConfig.SCCMServer = "MySCCM.MyDomain.Local"
$MyDMHConfig.SCCMSite = "XYZ"

# Current TimeZone Offset
$MyDMHConfig.TZOffset = ([System.TimeZoneInfo]::Local).BaseUtcOffset

# Get Script Path
if ([String]::IsNullOrEmpty($HostInvocation))
{
  $MyDMHConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($Script:MyInvocation.MyCommand.Path)
}
else
{
  $MyDMHConfig.ScriptPath = [System.IO.Path]::GetDirectoryName($HostInvocation.MyCommand.Path)
}

#endregion ******** MyDMH Configuration  ********

#region ******** MyDMH Form Custom Colors ********

$MyDMHColor = @{}

# Main Form Colors - Mine - Dark
$MyDMHColor.BackColor = [System.Drawing.Color]::Black
$MyDMHColor.ForeColor = [System.Drawing.Color]::DarkRed

# Default Color for Labels, CheckBoxes, and RadioButtons
$MyDMHColor.LabelForeColor = [System.Drawing.Color]::DarkRed

$MyDMHColor.ErrorForeColor = [System.Drawing.Color]::Red

# Default Color for Title Labels
$MyDMHColor.TitleBackColor = [System.Drawing.Color]::DimGray
$MyDMHColor.TitleForeColor = [System.Drawing.Color]::Black

# Default Color for GroupBoxes
$MyDMHColor.GroupForeColor = [System.Drawing.Color]::DarkRed

# Default Colors for TextBoxes, ComboBoxes, CheckedListBoxes, ListBoxes, ListViews, TreeViews, RichTextBoxes, DateTimePickers, and DataGridViews
$MyDMHColor.TextBackColor = [System.Drawing.Color]::LightGray
$MyDMHColor.TextForeColor = [System.Drawing.Color]::Black

# Default Color for Buttons
$MyDMHColor.ButtonBackColor = [System.Drawing.Color]::DarkGray
$MyDMHColor.ButtonForeColor = [System.Drawing.Color]::Black

#endregion ******** MyDMH Form Custom Colors ********

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

#region function New-MyListItem
function New-MyListItem()
{
  <#
    .SYNOPSIS
      Makes and Adds a New ListItem for a ComboBox or ListBox Control
    .DESCRIPTION
      Makes and Adds a New ListItem for a ComboBox or ListBox Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Value
    .PARAMETER Tag
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MyListItem -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [Object]$Control,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [parameter(Mandatory = $True)]
    [String]$Value,
    [Object]$Tag,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MyListItem"
  Try
  {
    If ($PassThru)
    {
      $Control.Items.Add(([PSCustomObject]@{"Text" = $Text; "Value" = $Value; "Tag" = $Tag}))
    }
    Else
    {
      [Void]$Control.Items.Add(([PSCustomObject]@{"Text" = $Text; "Value" = $Value; "Tag" = $Tag}))
    }
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MyListItem"
}
#endregion function New-MyListItem

#region function New-TreeNode
function New-TreeNode()
{
  <#
    .SYNOPSIS
      Makes and adds a New TreeNode to a TreeView Node
    .DESCRIPTION
      Makes and adds a New TreeNode to a TreeView Node
    .PARAMETER TreeNode
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER Tag
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER ImageIndex
    .PARAMETER SelectedImageIndex
    .PARAMETER ToolTip
    .PARAMETER AtTop
    .PARAMETER Checked
    .PARAMETER Expand
    .PARAMETER PassThru
    .EXAMPLE
      New-TreeNode -TreeNode $TreeNode -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Index")]
  param (
    [parameter(Mandatory = $True)]
    [Object]$TreeNode,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [Object]$Tag,
    [System.Drawing.FontFamily]$FontFamily = $MyDMHConfig.FontFamily,
    [Int]$FontSize = $MyDMHConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMHColor.TextBackColor,
    [System.Drawing.Color]$ForeColor = $MyDMHColor.TextForeColor,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [Int]$ImageIndex = -1,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [Int]$SelectedImageIndex = -1,
    [parameter(Mandatory = $True, ParameterSetName = "Key")]
    [String]$ImageKey,
    [parameter(Mandatory = $False, ParameterSetName = "Key")]
    [String]$SelectedImageKey,
    [String]$ToolTip,
    [switch]$AtTop,
    [switch]$Checked,
    [switch]$Expand,
    [switch]$AddChild,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-TreeNode"
  Try
  {
    #region $TempTreeNode = System.Windows.Forms.TreeNode
    if ($AddChild.IsPresent)
    {
      $TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode($Text, [System.Windows.Forms.TreeNode[]](@("$*$")))
    }
    else
    {
      $TempTreeNode = New-Object -TypeName System.Windows.Forms.TreeNode($Text)
    }
    if ($AtTop.IsPresent)
    {
      [Void]$TreeNode.Nodes.Insert(0, $TempTreeNode)
    }
    else
    {
      [Void]$TreeNode.Nodes.Add($TempTreeNode)
    }
    $TempTreeNode.Checked = $Checked
    $TempTreeNode.BackColor = $BackColor
    $TempTreeNode.ForeColor = $ForeColor
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempTreeNode.Name = $Name
    }
    else
    {
      $TempTreeNode.Name = $Text
    }
    $TempTreeNode.Tag = $Tag
    $TempTreeNode.NodeFont = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    Switch ($PSCmdlet.ParameterSetName)
    {
      "Index"
      {
        if ($ImageIndex -gt -1)
        {
          $TempTreeNode.ImageIndex = $ImageIndex
          if ($SelectedImageIndex -eq -1)
          {
            $TempTreeNode.SelectedImageIndex = $ImageIndex
          }
          else
          {
            $TempTreeNode.SelectedImageIndex = $SelectedImageIndex
          }
        }
        Break
      }
      "Key"
      {
        $TempTreeNode.ImageKey = $ImageKey
        if ($PSBoundParameters.ContainsKey("SelectedImageKey"))
        {
          $TempTreeNode.SelectedImageKey = $SelectedImageKey
        }
        else
        {
          $TempTreeNode.SelectedImageKey = $ImageKey
        }
        Break
      }
    }
    $TempTreeNode.ToolTipText = $ToolTip
    #endregion
    if ($Expand.IsPresent)
    {
      $TempTreeNode.Expand()
    }
    If ($PassThru.IsPresent)
    {
      $TempTreeNode
    }
    $TempTreeNode = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-TreeNode"
}
#endregion function New-TreeNode

#region function New-MenuItem
function New-MenuItem()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuItem for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER Check
    .PARAMETER ClickOnCheck
    .PARAMETER ShortcutKeys
    .PARAMETER Disable
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuItem -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [System.Drawing.Icon]$Icon,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [Switch]$Check,
    [Switch]$ClickOnCheck,
    [System.Windows.Forms.Keys]$ShortcutKeys = "None",
    [System.Drawing.FontFamily]$FontFamily = $MyDMHConfig.FontFamily,
    [Int]$FontSize = $MyDMHConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMHColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMHColor.ForeColor,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuItem"
  Try
  {
    #region $TempMenuItem = System.Windows.Forms.ToolStripMenuItem
    Write-Verbose -Message "Creating Form Control `$TempMenuItem"
    $TempMenuItem = New-Object -TypeName System.Windows.Forms.ToolStripMenuItem($Text)
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempMenuItem)
    }
    else
    {
      [Void]$Menu.Items.Add($TempMenuItem)
    }
    $TempMenuItem.TextAlign = $Alignment
    $TempMenuItem.BackColor = $BackColor
    $TempMenuItem.Checked = $Check
    $TempMenuItem.CheckOnClick = $ClickOnCheck
    $TempMenuItem.DisplayStyle = $DisplayStyle
    $TempMenuItem.Enabled = (-not $Disable)
    $TempMenuItem.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    $TempMenuItem.ForeColor = $ForeColor
    if ($PSBoundParameters.ContainsKey("Icon"))
    {
      $TempMenuItem.Image = $Icon
      $TempMenuItem.ImageAlign = $Alignment
      $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
    }
    else
    {
      $TempMenuItem.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
    }
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempMenuItem.Name = $Name
    }
    else
    {
      $TempMenuItem.Name = $Text
    }
    $TempMenuItem.ShortcutKeys = $ShortcutKeys
    $TempMenuItem.Tag = $Tag
    $TempMenuItem.ToolTipText = $ToolTip
    #endregion
    If ($PassThru)
    {
      $TempMenuItem
    }
    $TempMenuItem = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuItem"
}
#endregion function New-MenuItem

#region function New-MenuLabel
function New-MenuLabel()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuLabel for a Menu or ToolStrip Control
    .PARAMETER Control
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER ToolTip
    .PARAMETER Icon
    .PARAMETER DisplayStyle
    .PARAMETER Alignment
    .PARAMETER Tag
    .PARAMETER Disable
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-MenuLabel -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [String]$ToolTip,
    [System.Drawing.Icon]$Icon,
    [System.Windows.Forms.ToolStripItemDisplayStyle]$DisplayStyle = "Text",
    [System.Drawing.ContentAlignment]$Alignment = "MiddleCenter",
    [Object]$Tag,
    [Switch]$Disable,
    [System.Drawing.FontFamily]$FontFamily = $MyDMHConfig.FontFamily,
    [Int]$FontSize = $MyDMHConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [System.Drawing.Color]$BackColor = $MyDMHColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMHColor.ForeColor,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-MenuLabel"
  Try
  {
    #region $TempMenuLabel = System.Windows.Forms.ToolStripMenuLabel
    Write-Verbose -Message "Creating Form Control `$TempMenuLabel"
    $TempMenuLabel = New-Object -TypeName System.Windows.Forms.ToolStripLabel($Text)
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempMenuLabel)
    }
    else
    {
      [Void]$Menu.Items.Add($TempMenuLabel)
    }
    $TempMenuLabel.TextAlign = $Alignment
    $TempMenuLabel.BackColor = $BackColor
    $TempMenuLabel.DisplayStyle = $DisplayStyle
    $TempMenuLabel.Enabled = (-not $Disable)
    $TempMenuLabel.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    $TempMenuLabel.ForeColor = $ForeColor
    if ($PSBoundParameters.ContainsKey("Icon"))
    {
      $TempMenuLabel.Image = $Icon
      $TempMenuLabel.ImageAlign = $Alignment
      $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText
    }
    else
    {
      $TempMenuLabel.TextImageRelation = [System.Windows.Forms.TextImageRelation]::TextBeforeImage
    }
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempMenuLabel.Name = $Name
    }
    else
    {
        $TempMenuLabel.Name = $Text
    }
    $TempMenuLabel.Tag = $Tag
    $TempMenuLabel.ToolTipText = $ToolTip
    #endregion
    If ($PassThru)
    {
      $TempMenuLabel
    }
    $TempMenuLabel = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuLabel"
}
#endregion function New-MenuLabel

#region function New-MenuSeparator
function New-MenuSeparator()
{
  <#
    .SYNOPSIS
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .DESCRIPTION
      Makes and Adds a New MenuSeparator for a Menu or ToolStrip Control
    .PARAMETER Menu
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .EXAMPLE
      New-MenuSeparator -Menu $Menu
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [Object]$Menu,
    [System.Drawing.Color]$BackColor = $MyDMHColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMHColor.ForeColor
  )
  Write-Verbose -Message "Enter Function New-MenuSeparator"
  Try
  {
    #region $TempSeparator = System.Windows.Forms.ToolStripSeparator
    Write-Verbose -Message "Creating Form Control `$TempSeparator"
    $TempSeparator = New-Object -TypeName System.Windows.Forms.ToolStripSeparator
    if ($Menu.GetType().Name -eq "ToolStripMenuItem")
    {
      [Void]$Menu.DropDownItems.Add($TempSeparator)
    }
    else
    {
      [Void]$Menu.Items.Add($TempSeparator)
    }
    $TempSeparator.BackColor = $BackColor
    $TempSeparator.ForeColor = $ForeColor
    $TempSeparator.Name = "TempSeparator"
    $TempSeparator.Text = "TempSeparator"
    #endregion
    $TempSeparator = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-MenuSeparator"
}
#endregion function New-MenuSeparator

#region function New-ListViewItem
function New-ListViewItem()
{
  <#
    .SYNOPSIS
      Makes and adds a New ListViewItem to a ListView Control
    .DESCRIPTION
      Makes and adds a New ListViewItem to a ListView Control
    .PARAMETER ListView
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER FontStyle
    .PARAMETER Name
    .PARAMETER Text
    .PARAMETER SubItems
    .PARAMETER Tag
    .PARAMETER IndentCount
    .PARAMETER ImageIndex
    .PARAMETER Imagekey
    .PARAMETER Group
    .PARAMETER ToolTip
    .PARAMETER Checked
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-ListViewItem -ListView $listView -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListView]$ListView,
    [System.Drawing.Color]$BackColor = $MyDIColor.TextBackColor,
    [System.Drawing.Color]$ForeColor = $MyDIColor.TextForeColor,
    [System.Drawing.FontFamily]$FontFamily = $MyDIConfig.FontFamily,
    [String]$FontSize = $MyDIConfig.FontSize,
    [System.Drawing.FontStyle]$FontStyle = "Regular",
    [String]$Name,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String[]]$SubItems,
    [Object]$Tag,
    [parameter(Mandatory = $False, ParameterSetName = "Index")]
    [parameter(Mandatory = $False, ParameterSetName = "Key")]
    [Int]$IndentCount = 0,
    [parameter(Mandatory = $True, ParameterSetName = "Index")]
    [Int]$ImageIndex = -1,
    [parameter(Mandatory = $True, ParameterSetName = "Key")]
    [String]$ImageKey,
    [Object]$Group,
    [String]$ToolTip,
    [Switch]$Checked,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-ListViewItem"
  Try
  {
    #region $TempListViewItem = System.Windows.Forms.ListViewItem
    if ($PSCmdlet.ParameterSetName -eq "Default")
    {
      $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $Group)
    }
    else
    {
      if ($PSCmdlet.ParameterSetName -eq "Index")
      {
        $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $ImageIndex, $Group)
      }
      else
      {
        $TempListViewItem = New-Object -TypeName System.Windows.Forms.ListViewItem($Text, $ImageKey, $Group)
      }
      $TempListViewItem.IndentCount = $IndentCount
    }
    $TempListViewItem.BackColor = $BackColor
    $TempListViewItem.ForeColor = $ForeColor
    $TempListViewItem.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, $FontStyle, [System.Drawing.GraphicsUnit]::Point)
    if ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempListViewItem.Name = $Name
    }
    else
    {
      $TempListViewItem.Name = $Text
    }
    $TempListViewItem.Tag = $Tag
    if ($PSBoundParameters.ContainsKey("SubItems"))
    {
      $TempListViewItem.SubItems.AddRange($SubItems)
    }
    $TempListViewItem.ToolTipText = $ToolTip
    $TempListViewItem.Checked = $Checked.IsPresent
    #endregion
    [Void]$ListView.Items.Add($TempListViewItem)
    If ($PassThru.IsPresent)
    {
      $TempListViewItem
    }
    $TempListViewItem = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-ListViewItem"
}
#endregion function New-ListViewItem

#region function New-ColumnHeader
function New-ColumnHeader()
{
  <#
    .SYNOPSIS
      Makes and Adds a New ColumnHeader for a ListView Control
    .DESCRIPTION
      Makes and Adds a New ColumnHeader for a ListView Control
    .PARAMETER ListView
    .PARAMETER Text
    .PARAMETER Tag
    .PARAMETER Width
    .PARAMETER PassThru
    .EXAMPLE
      $NewItem = New-ColumnHeader -Text "Text" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [Object]$Tag,
    [Int]$Width = -2,
    [switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-ColumnHeader"
  Try
  {
    #region $TempColumnHeader = System.Windows.Forms.ColumnHeader
    $TempColumnHeader = New-Object -TypeName System.Windows.Forms.ColumnHeader
    [Void]$ListView.Columns.Add($TempColumnHeader)
    $TempColumnHeader.Tag = $Tag
    $TempColumnHeader.Text = $Text
    $TempColumnHeader.Name = $Text
    $TempColumnHeader.Width = $Width
    #endregion
    If ($PassThru)
    {
      $TempColumnHeader
    }
    $TempColumnHeader = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-ColumnHeader"
}
#endregion function New-ColumnHeader

#region function New-ListViewGroup
function New-ListViewGroup()
{
  <#
    .SYNOPSIS
      Makes and Adds a New ListViewGroup to a ListView Control
    .DESCRIPTION
      Makes and Adds a New ListViewGroup to a ListView Control
    .PARAMETER Header
    .PARAMETER Tag
    .PARAMETER Alignment
    .EXAMPLE
      $NewItem = New-ListViewGroup -Header "Header" -Tag "Tag"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.ListView]$ListView,
    [parameter(Mandatory = $True)]
    [String]$Header,
    [Object]$Tag,
    [System.Windows.Forms.HorizontalAlignment]$Alignment = "Left"
  )
  Write-Verbose -Message "Enter Function New-ListViewGroup"
  Try
  {
    #region $TempListViewGroup = System.Windows.Forms.ListViewGroup
    $TempListViewGroup = New-Object -TypeName System.Windows.Forms.ListViewGroup
    [Void]$ListView.Groups.Add($TempListViewGroup)
    $TempListViewGroup.Tag = $Tag
    $TempListViewGroup.Header = $Header
    $TempListViewGroup.Name = $Header
    $TempListViewGroup.HeaderAlignment = $Alignment
    #endregion
    $TempListViewGroup
    $TempListViewGroup = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-ListViewGroup"
}
#endregion function New-ListViewGroup

#region function New-TabPage
function New-TabPage()
{
  <#
    .SYNOPSIS
      Makes and adds a New TabPage to a TabControl Node
    .DESCRIPTION
      Makes and adds a New TabPage to a TabControl Node
    .PARAMETER TabControl
    .PARAMETER BackColor
    .PARAMETER ForeColor
    .PARAMETER FontFamily
    .PARAMETER FontSize
    .PARAMETER Text
    .PARAMETER Name
    .PARAMETER Tag
    .PARAMETER ImageIndex
    .PARAMETER ToolTip
    .PARAMETER Disabled
    .PARAMETER PassThru
    .EXAMPLE
      $TabPage = New-TabPage -TabControl  -Text "Text" -Tag "Tag" -PassThru
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory = $True)]
    [System.Windows.Forms.TabControl]$TabControl,
    [System.Drawing.Color]$BackColor = $MyDMHColor.BackColor,
    [System.Drawing.Color]$ForeColor = $MyDMHColor.ForeColor,
    [System.Drawing.FontFamily]$FontFamily = $MyDMHConfig.FontFamily,
    [Int]$FontSize = $MyDMHConfig.FontSize,
    [parameter(Mandatory = $True)]
    [String]$Text,
    [String]$Name,
    [Object]$Tag,
    [Int]$ImageIndex = -1,
    [String]$ToolTip,
    [Switch]$Disabled,
    [Switch]$PassThru
  )
  Write-Verbose -Message "Enter Function New-TabPage"
  Try
  {
    #region $TempTabPage = System.Windows.Forms.TabPage
    $TempTabPage = New-Object -TypeName System.Windows.Forms.TabPage
    $TabControl.Controls.Add($TempTabPage)
    $TempTabPage.BackColor = $BackColor
    $TempTabPage.ForeColor = $ForeColor
    $TempTabPage.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
    $TempTabPage.ImageIndex = $ImageIndex
    If ($PSBoundParameters.ContainsKey("Name"))
    {
      $TempTabPage.Name = $Name
    }
    else
    {
      $TempTabPage.Name = $Text
    }
    $TempTabPage.Tag = $Tag
    $TempTabPage.Text = $Text
    $TempTabPage.ToolTipText = $ToolTip
    $TempTabPage.Enabled = (-not $Disabled)
    #endregion
    If ($PassThru)
    {
      $TempTabPage
    }
    $TempTabPage = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function New-TabPage"
}
#endregion function New-TabPage

#region function Set-MyClipboard
function Set-MyClipboard()
{
  <#
    .SYNOPSIS
      Copies Object Data to the ClipBoard
    .DESCRIPTION
      Copies Object Data to the ClipBoard
    .PARAMETER MyData
    .PARAMETER Title
    .PARAMETER TitleColor
    .PARAMETER Columns
    .PARAMETER ColumnColor
    .PARAMETER RowEven
    .PARAMETER RowOdd
    .PARAMETER OfficeFix
    .PARAMETER PassThru
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title"
    .EXAMPLE
      $MyData | Set-MyClipBoard -Title "This is My Title"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Property "Property1", "Property2", "Property3"
    .EXAMPLE
      Set-MyClipBoard -MyData $MyData -Title "This is My Title" -Columns ([Ordered@{"Property1" = "Left"; "Property2" = "Right"; "Property3" = "Center"})
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True, ValueFromPipeline = $True)]
    [Object[]]$MyData,
    [String]$Title,
    [String]$TitleColor = "DodgerBlue",
    [parameter(Mandatory = $True, ParameterSetName = "Columns")]
    [System.Collections.Specialized.OrderedDictionary]$Columns,
    [parameter(Mandatory = $True, ParameterSetName = "Names")]
    [String[]]$Property,
    [String]$ColumnColor = "SkyBlue",
    [String]$RowEven = "White",
    [String]$RowOdd = "Gainsboro",
    [Switch]$OfficeFix,
    [Switch]$PassThru
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Begin Block"
    
    $HTMLStringBuilder = New-Object -TypeName System.Text.StringBuilder
    
    [Void]$HTMLStringBuilder.Append("Version:1.0`r`nStartHTML:000START`r`nEndHTML:00000END`r`nStartFragment:00FSTART`r`nEndFragment:0000FEND`r`n")
    [Void]$HTMLStringBuilder.Replace("000START", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<html><head><style>`r`nth { text-align: center; color: black; font: bold; background:$ColumnColor; }`r`ntd:nth-child(1) { text-align:right; }`r`ntable, th, td { border: 1px solid black; border-collapse: collapse; }`r`ntr:nth-child(odd) {background: $RowEven;}`r`ntr:nth-child($RowOdd) {background: gainsboro;}`r`n</style><title>$Title</title></head><body><!--StartFragment-->")
    [Void]$HTMLStringBuilder.Replace("00FSTART", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    $ObjectList = New-Object -TypeName System.Collections.ArrayList
    
    $GetColumns = $True
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Begin Block"
  }
  Process
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard Process Block"
    
    if ($GetColumns)
    {
      $Cols = [Ordered]@{ }
      Switch ($PSCmdlet.ParameterSetName)
      {
        "Columns"
        {
          $Cols = $Columns
          Break
        }
        "Names"
        {
          $Property | ForEach-Object -Process { $Cols.Add($PSItem, "Left") }
          Break
        }
        Default
        {
          $MyData[0].PSObject.Properties | Where-Object -FilterScript { $PSItem.MemberType -match "Property|NoteProperty" } | ForEach-Object -Process { $Cols.Add($PSItem.Name, "Left") }
          Break
        }
      }
      $ColNames = @($Cols.Keys)
      $GetColumns = $False
    }
    
    $ObjectList.AddRange(@($MyData | Select-Object -Property $ColNames))
    
    if ($PassThru.IsPresent)
    {
      $MyData
    }
    
    Write-Verbose -Message "Exit Function Set-MyClipboard Process Block"
  }
  End
  {
    Write-Verbose -Message "Enter Function Set-MyClipboard End Block"
    
    if ($OfficeFix.IsPresent)
    {
      if ($PSBoundParameters.ContainsKey("Title"))
      {
        [Void]$HTMLStringBuilder.Append("<table><tr><th style='background:$TitleColor;' colspan='$($Cols.Keys.Count)'>&nbsp;$($Title)&nbsp;</th></tr>")
      }
      else
      {
        [Void]$HTMLStringBuilder.Append("<table>")
      }
      [Void]$HTMLStringBuilder.Append(("<tr style='background:$ColumnColor;'><th>&nbsp;" + ($Cols.Keys -join "&nbsp;</th><th>&nbsp;") + "&nbsp;</th></tr>"))
      $Row = -1
      $RowColor = @($RowEven, $RowOdd)
      ForEach ($Item in $ObjectList)
      {
        [Void]$HTMLStringBuilder.Append("<tr style='background: $($RowColor[($Row = ($Row + 1) % 2)])'>")
        ForEach ($Key in $Cols.Keys)
        {
          [Void]$HTMLStringBuilder.Append("<td style='text-align:$($Cols[$Key])'>&nbsp;$($Item.$Key)&nbsp;</td>")
        }
        [Void]$HTMLStringBuilder.Append("</tr>")
      }
      [Void]$HTMLStringBuilder.Append("</table><br><br>")
    }
    else
    {
      [Void]$HTMLStringBuilder.Append(($ObjectList | ConvertTo-Html -Property $ColNames -Fragment | Out-String))
    }
    [Void]$HTMLStringBuilder.Replace("0000FEND", ("{0:X8}" -f $HTMLStringBuilder.Length))
    [Void]$HTMLStringBuilder.Append("<!--EndFragment--></body></html>")
    [Void]$HTMLStringBuilder.Replace("00000END", ("{0:X8}" -f $HTMLStringBuilder.Length))
    
    [System.Windows.Forms.Clipboard]::Clear()
    $DataObject = New-Object -TypeName System.Windows.Forms.DataObject
    $DataObject.SetData("Text", ($ObjectList | Select-Object -Property $ColNames | ConvertTo-Csv -NoTypeInformation | Out-String))
    $DataObject.SetData("HTML Format", $HTMLStringBuilder.ToString())
    [System.Windows.Forms.Clipboard]::SetDataObject($DataObject)
    
    $ObjectList = $Null
    $HTMLStringBuilder = $Null
    $DataObject = $Null
    $Cols = $Null
    $ColNames = $Null
    $Row = $Null
    $RowColor = $Null
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Verbose -Message "Exit Function Set-MyClipboard End Block"
  }
}
#endregion function Set-MyClipboard

#region function Send-MyEMail
function Send-MyEMail()
{
  <#
    .SYNOPSIS
      Sends an E-mail
    .DESCRIPTION
      Sends an E-mail
    .PARAMETER SMTPServer
    .PARAMETER SMTPPort
    .PARAMETER To
    .PARAMETER From
    .PARAMETER Subject
    .PARAMETER Body
    .PARAMETER MsgFile
    .PARAMETER IsHTML
    .PARAMETER CC
    .PARAMETER BCC
    .PARAMETER Attachments
    .PARAMETER Priority
    .EXAMPLE
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [String]$SMTPServer = $MyDMHConfig.SMTPServer,
    [Int]$SMTPPort = $MyDMHConfig.SMTPPort,
    [parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Enter To")]
    [System.Net.Mail.MailAddress[]]$To,
    [parameter(Mandatory = $True, HelpMessage = "Enter From")]
    [System.Net.Mail.MailAddress]$From,
    [parameter(Mandatory = $True, HelpMessage = "Enter Subject")]
    [String]$Subject,
    [parameter(Mandatory = $True, HelpMessage = "Enter Message Text")]
    [String]$Body,
    [Switch]$IsHTML,
    [System.Net.Mail.MailAddress[]]$CC,
    [System.Net.Mail.MailAddress[]]$BCC,
    [System.Net.Mail.Attachment[]]$Attachment,
    [ValidateSet("Low", "Normal", "High")]
    [System.Net.Mail.MailPriority]$Priority = "Normal"
  )
  Begin 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail Begin"
    $MyMessage = New-Object -TypeName System.Net.Mail.MailMessage
    $MyMessage.From = $From
    $MyMessage.Subject = $Subject
    if ($PSBoundParameters.ContainsKey("CC"))
    {
      foreach ($SendCC in $CC) 
      {
        $MyMessage.CC.Add($SendCC)
      }
    }
    if ($PSBoundParameters.ContainsKey("BCC"))
    {
      foreach ($SendBCC in $BCC) 
      {
        $MyMessage.BCC.Add($SendBCC)
      }
    }
    if ([System.IO.File]::Exists($Body)) 
    {
      $MyMessage.Body = $([System.IO.File]::ReadAllText($Body))
    }
    else
    {
      $MyMessage.Body = $Body
    }
    $MyMessage.IsBodyHtml = $IsHTML
    $MyMessage.Priority = $Priority
    if ($PSBoundParameters.ContainsKey("Attachment"))
    {
      foreach ($AttachedFile in $Attachment) 
      {
        $MyMessage.Attachments.Add($AttachedFile)
      }
    }
    Write-Verbose -Message "Exit Function Send-MyEMail Begin"
  }
  Process 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail Process"
    $MyMessage.To.Clear()
    foreach ($SendTo in $To) 
    {
      $MyMessage.To.Add($SendTo)
    }
    $SMTPClient = New-Object -TypeName System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
    $SMTPClient.Send($MyMessage)
    Write-Verbose -Message "Exit Function Send-MyEMail Process"
  }
  End 
  {
    Write-Verbose -Message "Enter Function Send-MyEMail End"
    Write-Verbose -Message "Exit Function Send-MyEMail End"
  }
}
#endregion function Send-MyEMail

#region function Get-MyADObject
function Get-MyADObject()
{
  <#
    .SYNOPSIS
      Searches AD and returns an AD SearchResultCollection 
    .DESCRIPTION
      Searches AD and returns an AD SearchResultCollection 
    .PARAMETER LDAPFilter
      AD Search LDAP Filter
    .PARAMETER PageSize
      Search Page Size
    .PARAMETER SizeLimit
      Search Search Size
    .PARAMETER SearchRoot
      Starting Search OU
    .PARAMETER SearchScope
      Search Scope
    .PARAMETER Sort
      Sort Direction
    .PARAMETER SortProperty
      Property to Sort By
    .PARAMETER PropertiesToLoad
      Properties to Load
    .PARAMETER UserName
      User Name to use when searching active directory
    .PARAMETER Password
      Password to use when searching active directory
    .EXAMPLE
      Get-MyADObject [<String>]
    .EXAMPLE
      Get-MyADObject -filter [<String>]
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [String]$LDAPFilter = "(objectClass=*)",
    [Long]$PageSize = 1000,
    [Long]$SizeLimit = 1000,
    [String]$SearchRoot = "LDAP://$($([ADSI]'').distinguishedName)",
    [ValidateSet("Base", "OneLevel", "Subtree")]
    [System.DirectoryServices.SearchScope]$SearchScope = "SubTree",
    [ValidateSet("Ascending", "Descending")]
    [System.DirectoryServices.SortDirection]$Sort = "Ascending",
    [String]$SortProperty,
    [String[]]$PropertiesToLoad,
    [String]$UserName,
    [String]$Password
  )
  Write-Verbose -Message "Enter Function Get-MyADObject"
  Try
  {
    $MySearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
    $MySearcher.PageSize = $PageSize
    $MySearcher.SizeLimit = $SizeLimit
    $MySearcher.Filter = $LDAPFilter
    Switch -regex ($SearchRoot)
    {
      "GC://*"
      {
        $MySearchRoot = $SearchRoot.ToUpper()
        $MySearcher.SearchScope = [System.DirectoryServices.SearchScope]::Subtree
        break
      }
      "LDAP://*"
      {
        $MySearchRoot = $SearchRoot.ToUpper()
        $MySearcher.SearchScope = $SearchScope
        break
      }
      Default
      {
        $MySearchRoot = "LDAP://$($SearchRoot.ToUpper())"
        $MySearcher.SearchScope = $SearchScope
        break
      }
    }
    if ($PSBoundParameters.ContainsKey("UserName") -and $PSBoundParameters.ContainsKey("Password"))
    {
      $MySearcher.SearchRoot = New-Object -TypeName System.DirectoryServices.DirectoryEntry($MySearchRoot, $UserName, $Password)
    }
    else
    {
      $MySearcher.SearchRoot = New-Object -TypeName System.DirectoryServices.DirectoryEntry($MySearchRoot)
    }
    if ($PSBoundParameters.ContainsKey("SortProperty"))
    {
      $MySearcher.Sort.PropertyName = $SortProperty
      $MySearcher.Sort.Direction = $Sort
    }
    if ($PSBoundParameters.ContainsKey("PropertiesToLoad"))
    {
      $MySearcher.PropertiesToLoad.AddRange($PropertiesToLoad)
    }
    $MySearcher.FindAll()
    $MySearcher = $Null
    $MySearchRoot = $Null
    
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Get-MyADObject"
}
#endregion  function Get-MyADObject

#region function Compress-MyData
function Compress-MyData()
{
  <#
    .SYNOPSIS
      Compress String Data
    .DESCRIPTION
      Compress String Data
    .PARAMETER Data
      Data to Compress
    .PARAMETER LineLength
      Max Line Length
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Compress-MyData -Data "String"
    .NOTES
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Int]$LineLength = 160
  )
  Write-Verbose -Message "Enter Function Compress-MyData"
  Try
  {
    $MemoryStream = New-Object -TypeName System.IO.MemoryStream
    $GZipStream = New-Object -TypeName System.IO.Compression.GZipStream($MemoryStream, [System.IO.Compression.CompressionMode]::Compress)
    $StreamWriter = New-Object -TypeName System.IO.StreamWriter($GZipStream, [System.Text.Encoding]::UTF8)
    $StreamWriter.Write($Data)
    $StreamWriter.Close()
    $Code = New-Object -TypeName System.Text.StringBuilder
    ForEach ($Line in @([System.Convert]::ToBase64String($MemoryStream.ToArray()) -split "(?<=\G.{$LineLength})(?=.)"))
    {
      [Void]$Code.AppendLine($Line)
    }
    $Code.ToString()
    $GZipStream.Close()
    $MemoryStream.Close()
    $MemoryStream = $Null
    $GZipStream = $Null
    $StreamWriter = $Null
    $Code = $Null
    $Line = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function Compress-MyData"
}
#endregion function Compress-MyData

#region function Decompress-MyData
function Decompress-MyData()
{
  <#
    .SYNOPSIS
      Decompress Compresed String Data
    .DESCRIPTION
      Decompress Compresed String Data
    .PARAMETER Data
      Data to Decompress
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Decompress-MyData -Data "String"
    .NOTES
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [String]$Data,
    [Switch]$AsString
  )
  Write-Verbose -Message "Enter Function Decompress-MyData"
  Try
  {
    $CompressedData = [System.Convert]::FromBase64String($Data)
    $MemoryStream = New-Object -TypeName System.IO.MemoryStream
    $MemoryStream.Write($CompressedData, 0, $CompressedData.Length)
    [Void]$MemoryStream.Seek(0, 0)
    $GZipStream = New-Object -TypeName System.IO.Compression.GZipStream($MemoryStream, [System.IO.Compression.CompressionMode]::Decompress)
    $StreamReader = New-Object -TypeName System.IO.StreamReader($GZipStream, [System.Text.Encoding]::UTF8)
    if ($AsString.IsPresent)
    {
      $StreamReader.ReadToEnd()
    }
    else
    {
      $ArrayList = New-Object -TypeName System.Collections.ArrayList
      $Buffer = New-Object -TypeName System.Char[] -ArgumentList 4096
      While ($StreamReader.EndOfStream -eq $False)
      {
        $Bytes = $StreamReader.Read($Buffer, 0, 4096)
        if ($Bytes)
        {
          $ArrayList.AddRange($Buffer[0..($Bytes - 1)])
        }
      }
      $ArrayList
      $ArrayList.Clear()
    }
    $StreamReader.Close()
    $GZipStream.Close()
    $MemoryStream.Close()
    $MemoryStream = $Null
    $GZipStream = $Null
    $StreamReader = $Null
    $CompressedData = $Null
    $ArrayList = $Null
    $Buffer = $Null
    $Bytes = $Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code:$($Error[0].InvocationInfo.Line)"
  }
  Write-Verbose -Message "Exit Function Decompress-MyData"
}
#endregion function Decompress-MyData

#region function Verify-MyWorkstation
function Verify-MyWorkstation()
{
  <#
    .SYNOPSIS
      Verify Remote Workstation is the Correct One
    .DESCRIPTION
      Verify Remote Workstation is the Correct One
    .PARAMETER ComputerName
      Name of the Computer to Verify
    .PARAMETER Credential
      Credentials to use when connecting to the Remote Computer
    .PARAMETER Wait
      How Long to Wait for Job to be Completed
    .PARAMETER Serial
      Return Serial Number
    .PARAMETER Mobile
      Check if System is Desktop / Laptop
    .EXAMPLE
      Verify-MyWorkstation -ComputerName "MyWorkstation"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
    [String[]]$ComputerName = [System.Environment]::MachineName,
    [PSCredential]$Credential,
    [ValidateRange(30, 300)]
    [Int]$Wait = 120,
    [Switch]$Serial,
    [Switch]$Mobile
  )
  Begin
  {
    Write-Verbose -Message "Enter Function Verify-MyWorkstation"

    # Primay Job Script to Verify Computer Name and WMI Functionality and Return Commonly used Properties
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyCompDataJob ScriptBlock ********
    $MyCompDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_ComputerSystem | Select-Object -Property "UserName", "Name", "PartOfDomain", "Domain", "Manufacturer", "Model", "TotalPhysicalMemory", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Secondary Job Script to Verify WMI Functionality and Return Commonly used Properties
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyOSDataJob ScriptBlock ********
    $MyOSDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_OperatingSystem | Select-Object -Property "Caption", "CSDVersion", "OSArchitecture", "ProductType", "LocalDateTime", "InstallDate", "LastBootUpTime", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Optional SerialNumber Job Script to Return Computer Serial Number
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyBIOSDataJob ScriptBlock ********
    $MyBIOSDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject (Get-WmiObject @Params -Class Win32_Bios | Select-Object -Property "SerialNumber", @{ "Name" = "Error"; "Expression" = { $False } }, @{ "Name" = "ErrorMessage"; "Expression" = { "" } })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion

    # Optional Mobile / ChassiType Job Script to Return Computer ChassisType (Desktop / Laptop)
    # Accepts ComputerName and Credentials as Parameters to make connection to remote computer
    #region ******** $MyChassisDataJob ScriptBlock ********
    $MyChassisDataJob = {
      param (
        [HashTable]$Params
      )
      $ErrorActionPreference = "Stop"
      Try
      {
        Write-Output -InputObject ([PSCustomObject]@{ "IsMobile" = $((@(8, 9, 10, 11, 12, 14) -contains (((Get-WmiObject @Params -Class Win32_SystemEnclosure).ChassisTypes)[0]))); "Error" = $False; "ErrorMessage" = "" })
      }
      Catch
      {
        Write-Output -InputObject ([PSCustomObject]@{ "Error" = $True; "ErrorMessage" = $($Error[0]) })
      }
    }
    #endregion
  }
  Process
  {
    Write-Verbose -Message "Enter Function Verify-MyWorkstation - Process"

    ForEach ($Computer in $ComputerName)
    {
      # Used to Calculate Verify Time
      $StartTime = [DateTime]::Now

      # Default Custom Object for the Verify Function to Return, Since it will always return a value I create the Object with the default error / failure values and update the poperties as needed
      #region ******** Custom Return Object $VerifyObject ********
      $VerifyObject = [PSCustomObject]@{
        "ComputerName" = $Computer.ToUpper();
        "Found" = $False;
        "UserName" = "";
        "Domain" = "";
        "DomainMember" = "";
        "ProductType" = 0;
        "Manufacturer" = "";
        "Model" = "";
        "IsMobile" = $False;
        "SerialNumber" = "";
        "Memory" = "";
        "OperatingSystem" = "";
        "ServicePack" = "";
        "Architecture" = "";
        "LocalDateTime" = "";
        "InstallDate" = "";
        "LastBootUpTime" = "";
        "IPAddress" = "";
        "Status" = "Off-Line";
        "Time" = [TimeSpan]::Zero;
        "ErrorMessage" = ""
      }
      #endregion

      if ($Computer -match "^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$")
      {
        Try
        {
          # Get IP Address from DNS, you want to do all remote checks using IP rather than ComputerName.  If you connect to a computer using the wrong name Get-WmiObject will fail and using the IP Address will not
          $IPAddresses = @([System.Net.Dns]::GetHostAddresses($Computer) | Where-Object -FilterScript { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } | Select-Object -ExpandProperty IPAddressToString)
          ForEach ($IPAddress in $IPAddresses)
          {
            # I think this is Faster than using Test-Connection
            if (((New-Object -TypeName System.Net.NetworkInformation.Ping).Send($IPAddress)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success)
            {
              # Default Common Get-WmiObject Options
              if ($PSBoundParameters.ContainsKey("Credential"))
              {
                $Params = @{
                  "ComputerName" = $IPAddress;
                  "Credential" = $Credential
                }
              }
              else
              {
                $Params = @{
                  "ComputerName" = $IPAddress
                }
              }

              # Start Setting Return Values as they are Found
              $VerifyObject.Status = "On-Line"
              $VerifyObject.IPAddress = $IPAddress

              # Start Primary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
              [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyCompDataJob)
              # Wait for Job to Finish or Wait Time has Elasped
              [Void](Wait-Job -Job $MyJob -Timeout $Wait)

              # Check if Job is Complete and has Data
              if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
              {
                # Get Job Data
                $MyCompData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                if ($MyCompData.Error)
                {
                  $VerifyObject.Status = "Verify Comp Error"
                  $VerifyObject.ErrorMessage = $MyCompData.ErrorMessage
                }
                else
                {
                  # Set Found Properties
                  $VerifyObject.ComputerName = "$($MyCompData.Name)"
                  $VerifyObject.UserName = "$($MyCompData.UserName)"
                  $VerifyObject.Domain = "$($MyCompData.Domain)"
                  $VerifyObject.DomainMember = "$($MyCompData.PartOfDomain)"
                  $VerifyObject.Manufacturer = "$($MyCompData.Manufacturer)"
                  $VerifyObject.Model = "$($MyCompData.Model)"
                  $VerifyObject.Memory = "$($MyCompData.TotalPhysicalMemory)"

                  # Verify Remote Computer is the Connect Computer, No need to get any more information
                  if ($MyCompData.Name -eq @($Computer.Split(".", [System.StringSplitOptions]::RemoveEmptyEntries))[0])
                  {
                    # Found Corrct Workstation
                    $VerifyObject.Found = $True

                    # Start Secondary Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                    [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyOSDataJob)
                    # Wait for Job to Finish or Wait Time has Elasped
                    [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                    # Check if Job is Complete and has Data
                    if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                    {
                      # Get Job Data
                      $MyOSData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                      if ($MyOSData.Error)
                      {
                        $VerifyObject.Status = "Verify Operating System Error"
                        $VerifyObject.ErrorMessage = $MyOSData.ErrorMessage
                      }
                      else
                      {
                        # Set Found Properties
                        $VerifyObject.ProductType = $MyOSData.ProductType
                        $VerifyObject.OperatingSystem = "$($MyOSData.Caption)"
                        $VerifyObject.ServicePack = "$($MyOSData.CSDVersion)"
                        $VerifyObject.Architecture = $(if ([String]::IsNullOrEmpty($MyOSData.OSArchitecture)) { "32-bit" } else { "$($MyOSData.OSArchitecture)" })
                        $VerifyObject.LocalDateTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LocalDateTime)
                        $VerifyObject.InstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.InstallDate)
                        $VerifyObject.LastBootUpTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($MyOSData.LastBootUpTime)

                        # Optional SerialNumber Job
                        if ($Serial)
                        {
                          # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                          [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyBIOSDataJob)
                          # Wait for Job to Finish or Wait Time has Elasped
                          [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                          # Check if Job is Complete and has Data
                          if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                          {
                            # Get Job Data
                            $MyBIOSData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                            if ($MyBIOSData.Error)
                            {
                              $VerifyObject.Status = "Verify SerialNumber Error"
                              $VerifyObject.ErrorMessage = $MyBIOSData.ErrorMessage
                            }
                            else
                            {
                              # Set Found Property
                              $VerifyObject.SerialNumber = "$($MyBIOSData.SerialNumber)"
                            }
                          }
                          else
                          {
                            $VerifyObject.Status = "Verify SerialNumber Error"
                            [Void](Remove-Job -Job $MyJob -Force)
                          }
                        }

                        # Optional Mobile / ChassisType Job
                        if ($Mobile)
                        {
                          # Start Optional Job, Pass IP Address and Credentials to Job Script to make Connection to Remote Computer
                          [Void]($MyJob = Start-Job -ArgumentList $Params -ScriptBlock $MyChassisDataJob)
                          # Wait for Job to Finish or Wait Time has Elasped
                          [Void](Wait-Job -Job $MyJob -Timeout $Wait)

                          # Check if Job is Complete and has Data
                          if ($MyJob.State -eq "Completed" -and $MyJob.HasMoreData)
                          {
                            # Get Job Data
                            $MyChassisData = Get-Job -ID $MyJob.ID | Receive-Job -AutoRemoveJob -Wait -Force
                            if ($MyChassisData.Error)
                            {
                              $VerifyObject.Status = "Verify is Mobile Error"
                              $VerifyObject.ErrorMessage = $MyChassisData.ErrorMessage
                            }
                            else
                            {
                              # Set Found Property
                              $VerifyObject.IsMobile = $($MyChassisData.IsMobile)
                            }
                          }
                          else
                          {
                            $VerifyObject.Status = "Verify is Mobile Error"
                            [Void](Remove-Job -Job $MyJob -Force)
                          }
                        }
                      }
                    }
                    else
                    {
                      $VerifyObject.Status = "Verify Operating System Error"
                      [Void](Remove-Job -Job $MyJob -Force)
                    }
                  }
                  else
                  {
                    $VerifyObject.Status = "Wrong Workstation Name"
                  }
                }
              }
              else
              {
                $VerifyObject.Status = "Verify Workstation Error"
                [Void](Remove-Job -Job $MyJob -Force)
              }
              # Beak out of Loop, Verify was a Success no need to try other IP Address is any
              Break
            }
          }
        }
        Catch
        {
          # Workstation Not in DNS
          $VerifyObject.Status = "Workstation Not in DNS"
        }
      }
      else
      {
        $VerifyObject.Status = "Invalid Computer Name"
      }

      # Calculate Verify Time
      $VerifyObject.Time = ([DateTime]::Now - $StartTime)

      # Return Custom Object with Collected Verify Information
      Write-Output -InputObject $VerifyObject

      $VerifyObject = $Null
      $Params = $Null
      $MyJob = $Null
      $MyCompData = $Null
      $MyOSData = $Null
      $MyBIOSData = $Null
      $MyChassisData = $Null
      $StartTime = $Null

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Write-Verbose -Message "Exit Function Verify-MyWorkstation - Process"
  }
  End
  {
    $MyCompDataJob = $Null
    $MyOSDataJob = $Null
    $MyBIOSDataJob = $Null
    $MyChassisDataJob = $Null

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Verbose -Message "Exit Function Verify-MyWorkstation"
  }
}
#endregion function Verify-MyWorkstation

#region function Write-MyLogFile
function Write-MyLogFile()
{
  <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER LogPath
    .PARAMETER LogFolder
    .PARAMETER LogName
    .PARAMETER Severity
    .PARAMETER Message
    .PARAMETER Context
    .PARAMETER Thread
    .PARAMETER StackInfo
    .PARAMETER MaxSize
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Write-MyLogFile -LogFolder "MyLogFolder" -Message "This is My Info Log File Message"
      Write-MyLogFile -LogFolder "MyLogFolder" -Severity "Info" -Message "This is My Info Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFolder "MyLogFolder" -Severity "Warning" -Message "This is My Warning Log File Message"
    .EXAMPLE
      Write-MyLogFile -LogFolder "MyLogFolder" -Severity "Error" -Message "This is My Error Log File Message"
    .NOTES
      Original Function By ken.sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "LogFolder")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "LogPath")]
    [ValidateScript({ [System.IO.Directory]::Exists($PSItem) })]
    [String]$LogPath = "$($ENV:SystemRoot)\Logs",
    [parameter(Mandatory = $False, ParameterSetName = "LogFolder")]
    [String]$LogFolder = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName),
    [String]$LogName = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName)).log",
    [ValidateSet("Info", "Warning", "Error")]
    [String]$Severity = "Info",
    [parameter(Mandatory = $True)]
    [String]$Message,
    [String]$Context = "",
    [Int]$Thread = $PID,
    [Switch]$StackInfo,
    [ValidateRange(0, 16777216)]
    [Int]$MaxSize = 5242880
  )
  Write-Verbose -Message "Enter Function Write-MyLogFile"

  if ($PSCmdlet.ParameterSetName -eq "LogPath")
  {
    $TempFile = "$LogPath\$LogName"
  }
  else
  {
    if (-not [System.IO.Directory]::Exists("$LogPath\$LogFolder"))
    {
      [Void][System.IO.Directory]::CreateDirectory("$LogPath\$LogFolder")
    }
    $TempFile = "$LogPath\$LogFolder\$LogName"
  }

  Switch ($Severity)
  {
    "Info" { $TempSeverity = 1; Break }
    "Warning" { $TempSeverity = 2; Break }
    "Error" { $TempSeverity = 3; Break }
  }

  $TempDate = [DateTime]::Now
  $TempSource = [System.IO.Path]::GetFileName($MyInvocation.ScriptName)
  if ($StackInfo.IsPresent)
  {
    $TempStack = @(Get-PSCallStack)
    $TempCommand = $TempCommand = [System.IO.Path]::GetFileNameWithoutExtension($TempStack[1].Command)
    $TempSource = "Line: $($TempStack[1].ScriptLineNumber) - Scope: $($TempStack.Count - 3)"
  }
  else
  {
    $TempCommand = [System.IO.Path]::GetFileNameWithoutExtension($TempSource)
  }

  if ([System.IO.File]::Exists($TempFile) -and $MaxSize -gt 0)
  {
    if (([System.IO.FileInfo]$TempFile).Length -gt $MaxSize)
    {
      $TempBackup = [System.IO.Path]::ChangeExtension($TempFile, "lo_")
      if ([System.IO.File]::Exists($TempBackup))
      {
        Remove-Item -Force -Path $TempBackup
      }
      Rename-Item -Force -Path $TempFile -NewName ([System.IO.Path]::GetFileName($TempBackup))
    }
  }
  Add-Content -Path $TempFile -Value ("<![LOG[{0}]LOG]!><time=`"{1}`" date=`"{2}`" component=`"{3}`" context=`"{4}`" type=`"{5}`" thread=`"{6}`" file=`"{7}`">" -f $Message, $($TempDate.ToString("HH:mm:ss.fff+000")), $($TempDate.ToString("MM-dd-yyyy")), $TempCommand, $Context, $TempSeverity, $Thread, $TempSource)

  $TempFile = $Null
  $TempBackup = $Null
  $TempSeverity = $Null
  $TempDate = $Null
  $TempSource = $Null
  $TempCommand = $Null
  $TempStack = $Null

  Write-Verbose -Message "Exit Function Write-MyLogFile"
}
#endregion

#region function Set-MyISScriptData
function Set-MyISScriptData()
{
  <#
    .SYNOPSIS
      Writes Script Data to the Registry
    .DESCRIPTION
      Writes Script Data to the Registry
    .PARAMETER Script
     Name of the Regsitry Key to write the values under. Defaults to the name of the script.
    .PARAMETER Name
     Name of the Value to write
    .PARAMETER Value
      The Data to write
    .PARAMETER MultiValue
      Write Multiple values to the Registry
    .PARAMETER User
      Write to the HKCU Registry Hive
    .PARAMETER Computer
      Write to the HKLM Registry Hive
    .PARAMETER Bitness
      Specify 32/64 bit HKLM Registry Hive
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Set-MyISScriptData -Name "Name" -Value "Value"

      Write REG_SZ value to the HKCU Registry Hive under the Default Script Name registry key
    .EXAMPLE
      Set-MyISScriptData -Name "Name" -Value @("This", "That") -User -Script "ScriptName"

      Write REG_MULTI_SZ value to the HKCU Registry Hive under the Specified Script Name registry key

      Single element arrays will be written as REG_SZ. To ensure they are written as REG_MULTI_SZ
      Use @() or (,) when specifing the Value paramter value
    .EXAMPLE
      Set-MyISScriptData -Name "Name" -Value (,8) -Bitness "64" -Computer

      Write REG_MULTI_SZ value to the 64 bit HKLM Registry Hive under the Default Script Name registry key

      Number arrays are written to the registry as strings.
    .EXAMPLE
      Set-MyISScriptData -Name "Name" -Value 0 -Computer

      Write REG_DWORD value to the HKLM Registry Hive under the Default Script Name registry key
    .EXAMPLE
      Set-MyISScriptData -MultiValue @{"Name" = "MyName"; "Number" = 4; "Array" = @("First", 2, "3rd", 4)} -Computer -Bitness "32"

      Write multiple values to the 32 bit HKLM Registry Hive under the Default Script Name registry key
    .NOTES
      Original Function By ken.sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "User")]
  param (
    [String]$Script = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName),
    [parameter(Mandatory = $True, ParameterSetName = "User")]
    [parameter(Mandatory = $True, ParameterSetName = "Comp")]
    [String]$Name,
    [parameter(Mandatory = $True, ParameterSetName = "User")]
    [parameter(Mandatory = $True, ParameterSetName = "Comp")]
    [Object]$Value,
    [parameter(Mandatory = $True, ParameterSetName = "UserMulti")]
    [parameter(Mandatory = $True, ParameterSetName = "CompMulti")]
    [HashTable]$MultiValue,
    [parameter(Mandatory = $False, ParameterSetName = "User")]
    [parameter(Mandatory = $False, ParameterSetName = "UserMulti")]
    [Switch]$User,
    [parameter(Mandatory = $True, ParameterSetName = "Comp")]
    [parameter(Mandatory = $True, ParameterSetName = "CompMulti")]
    [Switch]$Computer,
    [parameter(Mandatory = $False, ParameterSetName = "Comp")]
    [parameter(Mandatory = $False, ParameterSetName = "CompMulti")]
    [ValidateSet("32", "64", "All")]
    [String]$Bitness = "All"
  )
  Write-Verbose -Message "Enter Function Set-MyISScriptData"

  # Get Default Registry Paths
  $RegPaths = New-Object -TypeName System.Collections.ArrayList
  if ($Computer.IsPresent)
  {
    if ($Bitness -match "All|32")
    {
      [Void]$RegPaths.Add("Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node")
    }
    if ($Bitness -match "All|64")
    {
      [Void]$RegPaths.Add("Registry::HKEY_LOCAL_MACHINE\Software")
    }
  }
  else
  {
    [Void]$RegPaths.Add("Registry::HKEY_CURRENT_USER\Software")
  }

  # Create the Registry Keys if Needed.
  ForEach ($RegPath in $RegPaths)
  {
    if ([String]::IsNullOrEmpty((Get-Item -Path "$RegPath\MyISScriptData" -ErrorAction "SilentlyContinue")))
    {
      Try
      {
        [Void](New-Item -Path $RegPath -Name "MyISScriptData")
      }
      Catch
      {
        Throw "Error Creating Registry Key : MyISScriptData"
      }
    }
    if ([String]::IsNullOrEmpty((Get-Item -Path "$RegPath\MyISScriptData\$Script" -ErrorAction "SilentlyContinue")))
    {
      Try
      {
        [Void](New-Item -Path "$RegPath\MyISScriptData" -Name $Script)
      }
      Catch
      {
        Throw "Error Creating Registry Key : $Script"
      }
    }
  }

  # Write the values to the registry.
  Switch -regex ($PSCmdlet.ParameterSetName)
  {
    "Multi"
    {
      ForEach ($Key in $MultiValue.Keys)
      {
        if ($MultiValue[$Key] -is [Array])
        {
          $Data = [String[]]$MultiValue[$Key]
        }
        else
        {
          $Data = $MultiValue[$Key]
        }
        ForEach ($RegPath in $RegPaths)
        {
          [Void](Set-ItemProperty -Path "$RegPath\MyISScriptData\$Script" -Name $Key -Value $Data)
        }
      }
    }
    Default
    {
      if ($Value -is [Array])
      {
        $Data = [String[]]$Value
      }
      else
      {
        $Data = $Value
      }
      ForEach ($RegPath in $RegPaths)
      {
        [Void](Set-ItemProperty -Path "$RegPath\MyISScriptData\$Script" -Name $Name -Value $Data)
      }
    }
  }

  Write-Verbose -Message "Exit Function Set-MyISScriptData"
}
#endregion

#region function Get-MyISScriptData
function Get-MyISScriptData()
{
  <#
    .SYNOPSIS
      Reads Script Data from the Registry
    .DESCRIPTION
      Reads Script Data from the Registry
    .PARAMETER Script
     Name of the Regsitry Key to read the values from. Defaults to the name of the script.
    .PARAMETER Name
     Name of the Value to read
    .PARAMETER User
      Read from the HKCU Registry Hive
    .PARAMETER Computer
      Read from the HKLM Registry Hive
    .PARAMETER Bitness
      Specify 32/64 bit HKLM Registry Hive
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      $RegValues = Get-MyISScriptData -Name "Name"

      Read the value from the HKCU Registry Hive under the Default Script Name registry key
    .EXAMPLE
      $RegValues = Get-MyISScriptData -Name "Name" -User -Script "ScriptName"

      Read the value from the HKCU Registry Hive under the Specified Script Name registry key
    .EXAMPLE
      $RegValues = Get-MyISScriptData -Name "Name" -Computer

      Read the value from the 64 bit HKLM Registry Hive under the Default Script Name registry key
    .EXAMPLE
      $RegValues = Get-MyISScriptData -Name "Name" -Bitness "32" -Script "ScriptName" -Computer

      Read the value from the 32 bit HKLM Registry Hive under the Specified Script Name registry key
    .NOTES
      Original Function By ken.sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "User")]
  param (
    [String]$Script = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName),
    [String[]]$Name = "*",
    [parameter(Mandatory = $False, ParameterSetName = "User")]
    [Switch]$User,
    [parameter(Mandatory = $True, ParameterSetName = "Comp")]
    [Switch]$Computer,
    [parameter(Mandatory = $False, ParameterSetName = "Comp")]
    [ValidateSet("32", "64")]
    [String]$Bitness = "64"
  )
  Write-Verbose -Message "Enter Function Get-MyISScriptData"

  # Get Default Registry Path
  if ($Computer.IsPresent)
  {
    if ($Bitness -eq "64")
    {
      $RegPath = "Registry::HKEY_LOCAL_MACHINE\Software"
    }
    else
    {
      $RegPath = "Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node"
    }
  }
  else
  {
    $RegPath = "Registry::HKEY_CURRENT_USER\Software"
  }

  # Get the values from the registry.
  Get-ItemProperty -Path "$RegPath\MyISScriptData\$Script" -ErrorAction "SilentlyContinue" | Select-Object -Property $Name

  Write-Verbose -Message "Exit Function Get-MyISScriptData"
}
#endregion

#region function Remove-MyISScriptData
function Remove-MyISScriptData()
{
  <#
    .SYNOPSIS
      Removes Script Data from the Registry
    .DESCRIPTION
      Removes Script Data from the Registry
    .PARAMETER Script
     Name of the Regsitry Key to remove. Defaults to the name of the script.
    .PARAMETER User
      Remove from the HKCU Registry Hive
    .PARAMETER Computer
      Remove from the HKLM Registry Hive
    .PARAMETER Bitness
      Specify 32/64 bit HKLM Registry Hive
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      Remove-MyISScriptData

      Removes the default script registry key from the HKCU Registry Hive
    .EXAMPLE
      Remove-MyISScriptData -User -Script "ScriptName"

      Removes the Specified Script Name registry key from the HKCU Registry Hive
    .EXAMPLE
      Remove-MyISScriptData -Computer

      Removes the default script registry key from the 32/64 bit HKLM Registry Hive
    .EXAMPLE
      Remove-MyISScriptData -Computer -Script "ScriptName" -Bitness "32"

      Removes the Specified Script Name registry key from the 32 bit HKLM Registry Hive
    .NOTES
      Original Function By ken.sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "User")]
  param (
    [String]$Script = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName),
    [parameter(Mandatory = $False, ParameterSetName = "User")]
    [Switch]$User,
    [parameter(Mandatory = $True, ParameterSetName = "Comp")]
    [Switch]$Computer,
    [parameter(Mandatory = $False, ParameterSetName = "Comp")]
    [ValidateSet("32", "64", "All")]
    [String]$Bitness = "All"
  )
  Write-Verbose -Message "Enter Function Remove-MyISScriptData"

  # Get Default Registry Paths
  $RegPaths = New-Object -TypeName System.Collections.ArrayList
  if ($Computer.IsPresent)
  {
    if ($Bitness -match "All|32")
    {
      [Void]$RegPaths.Add("Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node")
    }
    if ($Bitness -match "All|64")
    {
      [Void]$RegPaths.Add("Registry::HKEY_LOCAL_MACHINE\Software")
    }
  }
  else
  {
    [Void]$RegPaths.Add("Registry::HKEY_CURRENT_USER\Software")
  }

  # Remove the values from the registry.
  ForEach ($RegPath in $RegPaths)
  {
    [Void](Remove-Item -Path "$RegPath\MyISScriptData\$Script")
  }

  Write-Verbose -Message "Exit Function Remove-MyISScriptData"
}
#endregion

#region function Test-MyClassLoaded
function Test-MyClassLoaded()
{
  <#
    .SYNOPSIS
      Test if Custom Class is Loaded
    .DESCRIPTION
      Test if Custom Class is Loaded
    .PARAMETER Name
      Name of Custom Class
    .INPUTS
    .OUTPUTS
    .EXAMPLE
      $IsLoaded = Test-MyClassLoaded -Name "CustomClass"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [parameter(Mandatory = $True, ParameterSetName = "Default")]
    [String]$Name
  )
  Write-Verbose -Message "Enter Function Test-MyClassLoaded"

  (-not [String]::IsNullOrEmpty(([Management.Automation.PSTypeName]$Name).Type))

  Write-Verbose -Message "Exit Function Test-MyClassLoaded"
}
#endregion

#region function Scale-MyForm
function Scale-MyForm()
{
  <#
    .SYNOPSIS
      Scale Form
    .DESCRIPTION
      Scale Form
    .PARAMETER Control
    .PARAMETER Scale
    .EXAMPLE
      Scale-MyForm -Control $Control -$Scale
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [Object]$Control = $MyDMHForm,
    [Single]$Scale = 1
  )
  Write-Verbose -Message "Enter Function Scale-MyForm"
  Try
  {
    if ($Control -is [System.Windows.Forms.Form])
    {
      $Control.Scale($Scale)
    }
    $Control.Font = New-Object -TypeName System.Drawing.Font($Control.Font.FontFamily, ($Control.Font.Size * $Scale), $Control.Font.Style, $Control.Font.Unit)
    if ([String]::IsNullOrEmpty($Control.PSObject.Properties.Match("Items")))
    {
      if ($Control.Controls.Count)
      {
        ForEach ($ChildControl in $Control.Controls)
        {
          Scale-MyForm -Control $ChildControl -Scale $Scale
        }
      }
    }
    else
    {
      ForEach ($Item in $Control.Items)
      {
        Scale-MyForm -Control $Item -Scale $Scale
      }
    }
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Function Scale-MyForm"
}
#endregion

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
    .PARAMETER Up
    .PARAMETER Down
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
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param (
    [System.Drawing.FontFamily]$FontFamily = $MyDMHConfig.FontFamily,
    [Single]$FontSize = $MyDMHConfig.FontSize,
    [String]$TextString = "The quick brown fox jumped over the lazy dogs back",
    [Parameter(Mandatory = $True, ParameterSetName = "Up")]
    [Switch]$Up,
    [Parameter(Mandatory = $True, ParameterSetName = "Down")]
    [Switch]$Down
  )
  Write-Verbose -Message "Enter Function Get-MyFontData"
  Try
  {
    $Graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    Switch ($PSCmdlet.ParameterSetName)
    {
      "Up"
      {
        $Ratio = $Graphics.DpiX / 96
        Break
      }
      "Down"
      {
        $Ratio = 96 / $Graphics.DpiX
        Break
      }
      Default
      {
        $Ratio = 1
        Break
      }
    }
    $BoldFont = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
    $MeasureString = $Graphics.MeasureString($TextString, $BoldFont)
    [PSCustomObject]@{
      "Ratio" = $Ratio;
      "Width" = [Math]::Floor($MeasureString.Width / $TextString.Length);
      "Height" = [Math]::Ceiling($MeasureString.Height);
      "DpiX" = $Graphics.DpiX;
      "DpiY" = $Graphics.DpiY;
      "Bold" = $BoldFont
      "Regular" = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
    }
    $BoldFont = $Null
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

# MyDMH Script Default Font Settings
$MyDMHConfig.FontData = Get-MyFontData -Up

#endregion ******** My Custom Functions ********

#region ******** MyDMH Custom Code ********

#region ******** $MyDMHFormICO ********
# Icons for Forms are 16x16
$MyDMHFormICO = @"
AAABAAEAEBAAAAAAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgTgAAHpfAACDQQAAiQIAAAAAAAAAAAAAAAAAAAAA/T8SBPxFEUb8UxJe/D4MMQAA
AAAAAAAAAgKODAAAiLkJCaH/CAi6/wAAsv8AAJDMAACQGQAAAAAAAAAA/VYlIf11Ldb8p0X//KU8//yRKP/8UxCr/EQMBwcHlpUnJ7L/QEDH/05O1v9DQ+D/DQ3f/wAAlbsAAAAAAAAAAP19Q8f9wnn//ceE//7I
hv/9vW3//KE0//xQEIgODp7vIyOx/zIyw/8+PtP/R0fg/0RE7P8EBMP/BgCTHulKOST+unX//saF//7Jif/+yIj//seD//29av/8ch3qBwea+xkZrf8iIr//LS3P/zU13f85Oer/Fhbe/wcAmTTnTkAy/sWG//7K
kP/+ypD//siK//3FgP/9wHT//Icx/QAAmsKOjtf/Gxu9/xsby/8hIdr/JSXo/xER1fQHA6oL51FFCP6me+7+6NH//syX//7Iiv/+wnz//bxr//16M80GBp82MjK19aqq5v85OdL/Nzfe/w8P5P8HB8l0AAAAAAAA
AAD+clpg/9a9/v7r1//+zpj//saE//2nWPv9XitFAAAAAAwMqC4GBq+qEBDA211d1cIRF79bAAAAAAAAAAAAAAAAAAAAAO90Wkn+kWy6/qV63P6Zd7X+Yjg9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFHlpDxCZ
QowSp0LUEKI90RGUM4NGhjgKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFKtQBx20V8060Hv/RtOC/znNd/8XvFX/DZo1wgqWNAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABq2
XWU/14b/UNuR/1rclf9i25f/WNaN/xq6VP8MlzVcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkxW6aPNyL/0nekv9R3pX/VtuU/1fYkP89znn/D6A8lwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAIMNthF/mpf9E4pb/R+CU/0nckP9I14n/P9B9/xKnRYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABy6ZShU4p/5tvXY/0Pilv8724r/OdWB/yzJb/0UqUw0AAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAKsR1VlTfnfOA7Lj/iuq6/zfPfPkYtVprAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAivWoSJcNwVDLEdVk0um0bAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAw8MAAAGAAAABgAAAAAAAAAAAAAAAAAAAAYAAAIPBAAD4HwAA8A8AAPAPAADwDwAA8A8AAPAPAAD4HwAA/D8AAA==
"@
#endregion ******** $MyDMHFormICO ********

#region ******** $MyDMHFormLogo ********
#endregion ******** $MyDMHFormLogo ********

#endregion ******** MyDMH Custom Code ********


#region function Show-MyDMHelpDialog
function Show-MyDMHelpDialog()
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
      Show-MyDMHelpDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [String]$Title = "Edit-MyDesktopMenus Help",
    [System.Windows.Forms.Form]$Owner = $MyDMForm,
    [Int]$FormSpacer = $MyDMConfig.FormSpacer,
    [Object]$FontData = $MyDMConfig.FontData,
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
  Write-Verbose -Message "Enter Function Show-MyDMHelpDialog"
  $MyDMHFormComponents = New-Object -TypeName System.ComponentModel.Container

  #region $MyDMHToolTip = System.Windows.Forms.ToolTip
  Write-Verbose -Message "Creating Form Control `$MyDMHToolTip"
  $MyDMHToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMHFormComponents)
  #$MyDMHToolTip.Active = $True
  #$MyDMHToolTip.AutomaticDelay = 500
  #$MyDMHToolTip.AutoPopDelay = 5000
  #$MyDMHToolTip.BackColor = [System.Drawing.SystemColors]::Info
  #$MyDMHToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
  #$MyDMHToolTip.InitialDelay = 500
  #$MyDMHToolTip.IsBalloon = $False
  #$MyDMHToolTip.OwnerDraw = $False
  #$MyDMHToolTip.ReshowDelay = 100
  #$MyDMHToolTip.ShowAlways = $False
  #$MyDMHToolTip.Site = System.ComponentModel.ISite
  #$MyDMHToolTip.StripAmpersands = $False
  #$MyDMHToolTip.Tag = $Null
  #$MyDMHToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
  $MyDMHToolTip.ToolTipTitle = "$($MyDMHConfig.ScriptName) - $($MyDMHConfig.ScriptVersion)"
  #$MyDMHToolTip.UseAnimation = $True
  #$MyDMHToolTip.UseFading = $True
  #endregion
  #$MyDMHToolTip.SetToolTip($FormControl, "Form Control Help")

  #region $MyDMHForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDMHForm"
  $MyDMHForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDMHForm.BackColor = $MyDMHColor.BackColor
  #$MyDMHForm.ControlBox = $True
  $MyDMHForm.Font = $MyDMHConfig.FontData.Regular
  $MyDMHForm.ForeColor = $MyDMHColor.ForeColor
  $MyDMHForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  $MyDMHForm.Icon = [System.Drawing.Icon]([System.Convert]::FromBase64String(($MyDMHFormICO)))
  #$MyDMHForm.MaximizeBox = $True
  #$MyDMHForm.Menu = System.Windows.Forms.MainMenu
  #$MyDMHForm.MinimizeBox = $True
  $MyDMHForm.MinimumSize = $Owner.MinimumSize
  $MyDMHForm.Name = "MyDMHForm"
  #$MyDMHForm.Owner = System.Windows.Forms.Form
  #$MyDMHForm.ShowIcon = $True
  #$MyDMHForm.ShowInTaskbar = $True
  $MyDMHForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  #$MyDMHForm.TabIndex = 0
  #$MyDMHForm.TabStop = $True
  $MyDMHForm.Text = $Title
  #endregion
  $MyDMHToolTip.SetToolTip($MyDMHForm, "Help for Control $($MyDMHForm.Name)")

  #region function Start-MyDMHFormShown
  function Start-MyDMHFormShown()
  {
    <#
      .SYNOPSIS
        Shown event for the MyDMHForm Control
      .DESCRIPTION
        Shown event for the MyDMHForm Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMHFormShown -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Shown Event for `$MyDMHForm"
    Try
    {
      $MyDMHConfig.AutoExit = 0
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      $Sender.Refresh()
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Shown Event for `$MyDMHForm"
  }
  #endregion function Start-MyDMHFormShown
  $MyDMHForm.add_Shown({Start-MyDMHFormShown -Sender $This -EventArg $PSItem})

  #region ******** $MyDMHForm Controls ********

  #region $MyDMHRichTextBox = System.Windows.Forms.RichTextBox
  Write-Verbose -Message "Creating Form Control `$MyDMHRichTextBox"
  $MyDMHRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
  $MyDMHForm.Controls.Add($MyDMHRichTextBox)
  #$MyDMHRichTextBox.AcceptsTab = $False
  #$MyDMHRichTextBox.AccessibleDefaultActionDescription = ""
  #$MyDMHRichTextBox.AccessibleDescription = ""
  #$MyDMHRichTextBox.AccessibleName = ""
  #$MyDMHRichTextBox.AccessibleRole = [System.Windows.Forms.AccessibleRole]::Default
  #$MyDMHRichTextBox.AllowDrop = $False
  #$MyDMHRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")
  #$MyDMHRichTextBox.AutoScrollOffset = New-Object -TypeName System.Drawing.Point(0, 0)
  #$MyDMHRichTextBox.AutoSize = $False
  #$MyDMHRichTextBox.AutoWordSelection = $False
  $MyDMHRichTextBox.BackColor = $MyDMHColor.TextBackColor
  #$MyDMHRichTextBox.BackgroundImage = [System.Drawing.Image]([System.Convert]::FromBase64String($ImageFile))
  #$MyDMHRichTextBox.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
  #$MyDMHRichTextBox.BindingContext = System.Windows.Forms.BindingContext
  #$MyDMHRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  #$MyDMHRichTextBox.Bounds = New-Object -TypeName System.Windows.Forms.Padding(0, 0, 100, 96)
  #$MyDMHRichTextBox.BulletIndent = 0
  #$MyDMHRichTextBox.Capture = $False
  #$MyDMHRichTextBox.CausesValidation = $True
  #$MyDMHRichTextBox.ClientSize = New-Object -TypeName System.Drawing.Size(96, 92)
  #$MyDMHRichTextBox.ContextMenu = System.Windows.Forms.ContextMenu
  #$MyDMHRichTextBox.ContextMenuStrip = System.Windows.Forms.ContextMenuStrip
  #$MyDMHRichTextBox.Cursor = [System.Windows.Forms.Cursors]::Default
  #$MyDMHRichTextBox.DetectUrls = $True
  $MyDMHRichTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
  #$MyDMHRichTextBox.EnableAutoDragDrop = $False
  #$MyDMHRichTextBox.Enabled = $True
  $MyDMHRichTextBox.Font = $MyDMHConfig.FontData.Regular
  $MyDMHRichTextBox.ForeColor = $MyDMHColor.TextForeColor
  #$MyDMHRichTextBox.Height = 96
  #$MyDMHRichTextBox.HideSelection = $True
  #$MyDMHRichTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
  #$MyDMHRichTextBox.IsAccessible = $False
  #$MyDMHRichTextBox.LanguageOption = [System.Windows.Forms.RichTextBoxLanguageOptions]::AutoFont, DualFont
  #$MyDMHRichTextBox.Left = 0
  #$MyDMHRichTextBox.Lines = @()
  #$MyDMHRichTextBox.Location = New-Object -TypeName System.Drawing.Point($MyDMHConfig.FormSpacer, $MyDMHConfig.FormSpacer)
  #$MyDMHRichTextBox.Margin = New-Object -TypeName System.Windows.Forms.Padding(3, 3, 3, 3)
  #$MyDMHRichTextBox.MaximumSize = New-Object -TypeName System.Drawing.Size(0, 0)
  #$MyDMHRichTextBox.MaxLength = 2147483647
  #$MyDMHRichTextBox.MinimumSize = New-Object -TypeName System.Drawing.Size(0, 0)
  #$MyDMHRichTextBox.Modified = $False
  #$MyDMHRichTextBox.Multiline = $True
  $MyDMHRichTextBox.Name = "MyDMHRichTextBox"
  #$MyDMHRichTextBox.Padding = New-Object -TypeName System.Windows.Forms.Padding(0, 0, 0, 0)
  #$MyDMHRichTextBox.Parent = System.Windows.Forms.Control
  #$MyDMHRichTextBox.ReadOnly = $False
  #$MyDMHRichTextBox.Region = System.Drawing.Region
  #$MyDMHRichTextBox.RichTextShortcutsEnabled = $True
  #$MyDMHRichTextBox.RightMargin = 0
  #$MyDMHRichTextBox.RightToLeft = [System.Windows.Forms.RightToLeft]::No
  #$MyDMHRichTextBox.Rtf = "{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}\viewkind4\uc1\pard\f0\fs17\par}"
  #$MyDMHRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
  #$MyDMHRichTextBox.SelectedRtf = "{\rtf1\ansi\ansicpg1252\deff0\deflang1033\uc1}"
  #$MyDMHRichTextBox.SelectedText = ""
  #$MyDMHRichTextBox.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left
  #$MyDMHRichTextBox.SelectionBullet = $False
  #$MyDMHRichTextBox.SelectionCharOffset = 0
  $MyDMHRichTextBox.SelectionFont = $MyDMHConfig.FontData.Regular
  #$MyDMHRichTextBox.SelectionHangingIndent = 0
  #$MyDMHRichTextBox.SelectionIndent = 0
  #$MyDMHRichTextBox.SelectionLength = 0
  #$MyDMHRichTextBox.SelectionProtected = $False
  #$MyDMHRichTextBox.SelectionRightIndent = 0
  #$MyDMHRichTextBox.SelectionStart = 0
  #$MyDMHRichTextBox.SelectionTabs = @()
  #$MyDMHRichTextBox.ShortcutsEnabled = $True
  #$MyDMHRichTextBox.ShowSelectionMargin = $False
  #$MyDMHRichTextBox.Site = System.ComponentModel.ISite
  #$MyDMHRichTextBox.Size = New-Object -TypeName System.Drawing.Size(100, 96)
  #$MyDMHRichTextBox.TabIndex = 0
  #$MyDMHRichTextBox.TabStop = $True
  #$MyDMHRichTextBox.Tag = $Null
  $MyDMHRichTextBox.Text = "MyDMHRichTextBox"
  #$MyDMHRichTextBox.Top = 0
  #$MyDMHRichTextBox.UseWaitCursor = $False
  #$MyDMHRichTextBox.Visible = $True
  #$MyDMHRichTextBox.Width = 100
  #$MyDMHRichTextBox.WindowTarget = System.Windows.Forms.IWindowTarget
  #$MyDMHRichTextBox.WordWrap = $True
  #$MyDMHRichTextBox.ZoomFactor = 1
  #endregion
  $MyDMHToolTip.SetToolTip($MyDMHRichTextBox, "Help for Control $($MyDMHRichTextBox.Name)")



  #region $MyDMHMenuStrip = System.Windows.Forms.MenuStrip
  Write-Verbose -Message "Creating Form Control `$MyDMHMenuStrip"
  $MyDMHMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
  $MyDMHForm.Controls.Add($MyDMHMenuStrip)
  $MyDMHForm.MainMenuStrip = $MyDMHMenuStrip
  $MyDMHMenuStrip.BackColor = $MyDMHColor.BackColor
  $MyDMHMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left
  $MyDMHMenuStrip.Font = $MyDMHConfig.FontData.Regular
  $MyDMHMenuStrip.ForeColor = $MyDMHColor.ForeColor
  $MyDMHMenuStrip.Location = New-Object -TypeName System.Drawing.Point($MyDMHConfig.FormSpacer, $MyDMHConfig.FormSpacer)
  $MyDMHMenuStrip.Name = "MyDMHMenuStrip"
  #$MyDMHMenuStrip.ShowItemToolTips = $False
  #$MyDMHMenuStrip.TabIndex = 0
  #$MyDMHMenuStrip.TabStop = $False
  #$MyDMHMenuStrip.Tag = $Null
  $MyDMHMenuStrip.Text = "MyDMHMenuStrip"
  $MyDMHMenuStrip.TextDirection = [System.Windows.Forms.ToolStripTextDirection]::Horizontal
  #$MyDMHMenuStrip.Top = 0
  #$MyDMHMenuStrip.UseWaitCursor = $False
  #$MyDMHMenuStrip.Visible = $True
  #$MyDMHMenuStrip.WindowTarget = System.Windows.Forms.IWindowTarget
  #endregion

  #region ******** $MyDMHMenuStrip MenuStrip MenuItems ********

  #region function Start-MyDMHToolStripButtonClick
  function Start-MyDMHToolStripButtonClick()
  {
    <#
      .SYNOPSIS
        Click event for the MyDMHToolStripButton Control
      .DESCRIPTION
        Click event for the MyDMHToolStripButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDMHToolStripButtonClick -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Click Event for `$MyDMHToolStripButton"
    Try
    {
      $MyDMHConfig.AutoExit = 0
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
      Switch ($Sender.Name)
      {
        "Close"
        {
          $MyDMHForm.Close()
          Break
        }
      }
      #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
      Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
      Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
      Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
    }
    Write-Verbose -Message "Exit Click Event for `$MyDMHToolStripButton"
  }
  #endregion function Start-MyDMHToolStripButtonClick
  #$MyDMHToolStripButton.add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  #(New-MenuItem -Menu $MyDMHMenuStrip -Text "Text" -Tag "Tag" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  #$NewMenuItem = New-MenuItem -Menu $MyDMHMenuStrip -Text "Text" -Tag "Tag" -PassThru
  #$NewMenuItem.add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})

  New-MenuSeparator -Menu $MyDMHMenuStrip
  New-MenuLabel -Menu $MyDMHMenuStrip -Text "Help Menu" -FontStyle "Bold" -ForeColor "Yellow"
  New-MenuSeparator -Menu $MyDMHMenuStrip

  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Introduction" -Text "Introduction" -Tag "Introduction" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Menu" -Text "Desktop Menu" -Tag "Menu" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Command" -Text "Menu Command" -Tag "Command" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  New-MenuSeparator -Menu $MyDMHMenuStrip
  (New-MenuItem -Menu $MyDMHMenuStrip -Name "Close" -Text "Close" -Tag "Close" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
  New-MenuSeparator -Menu $MyDMHMenuStrip

  #endregion ******** $MyDMHMenuStrip MenuStrip MenuItems ********




  #region $MyDMHTopPanel = System.Windows.Forms.Panel
  Write-Verbose -Message "Creating Form Control `$MyDMHTopPanel"
  $MyDMHTopPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyDMHForm.Controls.Add($MyDMHTopPanel)
  $MyDMHTopPanel.BackColor = $MyDMHColor.BackColor
  $MyDMHTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
  $MyDMHTopPanel.ForeColor = $MyDMHColor.ForeColor
  $MyDMHTopPanel.Name = "MyDMHTopPanel"
  $MyDMHTopPanel.Text = "MyDMHTopPanel"
  #endregion

  #region ******** $MyDMHTopPanel Controls ********

  #region $MyDMHTopLabel = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDMHTopLabel"
  $MyDMHTopLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyDMHTopPanel.Controls.Add($MyDMHTopLabel)
  #$MyDMHTopLabel.AccessibleDefaultActionDescription = ""
  #$MyDMHTopLabel.AccessibleDescription = ""
  #$MyDMHTopLabel.AccessibleName = ""
  #$MyDMHTopLabel.AccessibleRole = [System.Windows.Forms.AccessibleRole]::Default
  #$MyDMHTopLabel.AllowDrop = $False
  #$MyDMHTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")
  $MyDMHTopLabel.BackColor = $MyDMHColor.TitleBackColor
  $MyDMHTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  #$MyDMHTopLabel.Dock = [System.Windows.Forms.DockStyle]::None
  $MyDMHTopLabel.Font = New-Object -TypeName System.Drawing.Font($MyDMHConfig.FontFamily, ($MyDMHConfig.FontSize * 1.5), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
  $MyDMHTopLabel.ForeColor = $MyDMHColor.TitleForeColor
  $MyDMHTopLabel.Location = New-Object -TypeName System.Drawing.Point(($MyDMHConfig.FormSpacer / 1), ($MyDMHConfig.FormSpacer / 1))
  $MyDMHTopLabel.Name = "MyDMHTopLabel"
  $MyDMHTopLabel.Text = $Title
  $MyDMHTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
  #endregion
  $MyDMHTopLabel.Size = New-Object -TypeName System.Drawing.Size(($MyDMHTopPanel.ClientSize.Width - ($MyDMHConfig.FormSpacer * 2)), $MyDMHTopLabel.PreferredHeight)
    
  $MyDMHTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Right + ($MyDMHConfig.FormSpacer / 1)), ($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Bottom + ($MyDMHConfig.FormSpacer / 1)))

  $MyDMHTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

  #endregion ******** $MyDMHTopPanel Controls ********



  #$MyDMHForm.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Right + $MyDMHConfig.FormSpacer), ($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Bottom + $MyDMHConfig.FormSpacer))

  #endregion ******** $MyDMHForm Controls ********
  Write-Verbose -Message "Exit Function Show-MyDMHelpDialog"
}
#endregion function Show-MyDMHelpDialog

$Title = "Edit-MyDesktopMenus Help"

#region ******** $MyDMHForm ********

$MyDMHFormComponents = New-Object -TypeName System.ComponentModel.Container

#region $MyDMHToolTip = System.Windows.Forms.ToolTip
Write-Verbose -Message "Creating Form Control `$MyDMHToolTip"
$MyDMHToolTip = New-Object -TypeName System.Windows.Forms.ToolTip($MyDMHFormComponents)
#$MyDMHToolTip.Active = $True
#$MyDMHToolTip.AutomaticDelay = 500
#$MyDMHToolTip.AutoPopDelay = 5000
#$MyDMHToolTip.BackColor = [System.Drawing.SystemColors]::Info
#$MyDMHToolTip.ForeColor = [System.Drawing.SystemColors]::InfoText
#$MyDMHToolTip.InitialDelay = 500
#$MyDMHToolTip.IsBalloon = $False
#$MyDMHToolTip.OwnerDraw = $False
#$MyDMHToolTip.ReshowDelay = 100
#$MyDMHToolTip.ShowAlways = $False
#$MyDMHToolTip.Site = System.ComponentModel.ISite
#$MyDMHToolTip.StripAmpersands = $False
#$MyDMHToolTip.Tag = $Null
#$MyDMHToolTip.ToolTipIcon = [System.Windows.Forms.ToolTipIcon]::None
$MyDMHToolTip.ToolTipTitle = "$($MyDMHConfig.ScriptName) - $($MyDMHConfig.ScriptVersion)"
#$MyDMHToolTip.UseAnimation = $True
#$MyDMHToolTip.UseFading = $True
#endregion
#$MyDMHToolTip.SetToolTip($FormControl, "Form Control Help")

#region $MyDMHForm = System.Windows.Forms.Form
Write-Verbose -Message "Creating Form Control `$MyDMHForm"
$MyDMHForm = New-Object -TypeName System.Windows.Forms.Form
$MyDMHForm.BackColor = $MyDMHColor.BackColor
#$MyDMHForm.ControlBox = $True
$MyDMHForm.Font = $MyDMHConfig.FontData.Regular
$MyDMHForm.ForeColor = $MyDMHColor.ForeColor
$MyDMHForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$MyDMHForm.Icon = [System.Drawing.Icon]([System.Convert]::FromBase64String(($MyDMHFormICO)))
#$MyDMHForm.MaximizeBox = $True
#$MyDMHForm.Menu = System.Windows.Forms.MainMenu
#$MyDMHForm.MinimizeBox = $True
$MyDMHForm.MinimumSize = $Owner.MinimumSize
$MyDMHForm.Name = "MyDMHForm"
#$MyDMHForm.Owner = System.Windows.Forms.Form
#$MyDMHForm.ShowIcon = $True
#$MyDMHForm.ShowInTaskbar = $True
$MyDMHForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
#$MyDMHForm.TabIndex = 0
#$MyDMHForm.TabStop = $True
$MyDMHForm.Text = $Title
#endregion
$MyDMHToolTip.SetToolTip($MyDMHForm, "Help for Control $($MyDMHForm.Name)")

#region function Start-MyDMHFormShown
function Start-MyDMHFormShown()
{
  <#
    .SYNOPSIS
      Shown event for the MyDMHForm Control
    .DESCRIPTION
      Shown event for the MyDMHForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMHFormShown -Sender $Sender -EventArg $EventArg
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
  Write-Verbose -Message "Enter Shown Event for `$MyDMHForm"
  Try
  {
    $MyDMHConfig.AutoExit = 0
    #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $Sender.Refresh()
    #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Shown Event for `$MyDMHForm"
}
#endregion function Start-MyDMHFormShown
$MyDMHForm.add_Shown({Start-MyDMHFormShown -Sender $This -EventArg $PSItem})

#region ******** $MyDMHForm Controls ********

#region $MyDMHRichTextBox = System.Windows.Forms.RichTextBox
Write-Verbose -Message "Creating Form Control `$MyDMHRichTextBox"
$MyDMHRichTextBox = New-Object -TypeName System.Windows.Forms.RichTextBox
$MyDMHForm.Controls.Add($MyDMHRichTextBox)
#$MyDMHRichTextBox.AcceptsTab = $False
#$MyDMHRichTextBox.AccessibleDefaultActionDescription = ""
#$MyDMHRichTextBox.AccessibleDescription = ""
#$MyDMHRichTextBox.AccessibleName = ""
#$MyDMHRichTextBox.AccessibleRole = [System.Windows.Forms.AccessibleRole]::Default
#$MyDMHRichTextBox.AllowDrop = $False
#$MyDMHRichTextBox.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")
#$MyDMHRichTextBox.AutoScrollOffset = New-Object -TypeName System.Drawing.Point(0, 0)
#$MyDMHRichTextBox.AutoSize = $False
#$MyDMHRichTextBox.AutoWordSelection = $False
$MyDMHRichTextBox.BackColor = $MyDMHColor.TextBackColor
#$MyDMHRichTextBox.BackgroundImage = [System.Drawing.Image]([System.Convert]::FromBase64String($ImageFile))
#$MyDMHRichTextBox.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Tile
#$MyDMHRichTextBox.BindingContext = System.Windows.Forms.BindingContext
#$MyDMHRichTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
#$MyDMHRichTextBox.Bounds = New-Object -TypeName System.Windows.Forms.Padding(0, 0, 100, 96)
#$MyDMHRichTextBox.BulletIndent = 0
#$MyDMHRichTextBox.Capture = $False
#$MyDMHRichTextBox.CausesValidation = $True
#$MyDMHRichTextBox.ClientSize = New-Object -TypeName System.Drawing.Size(96, 92)
#$MyDMHRichTextBox.ContextMenu = System.Windows.Forms.ContextMenu
#$MyDMHRichTextBox.ContextMenuStrip = System.Windows.Forms.ContextMenuStrip
#$MyDMHRichTextBox.Cursor = [System.Windows.Forms.Cursors]::Default
#$MyDMHRichTextBox.DetectUrls = $True
$MyDMHRichTextBox.Dock = [System.Windows.Forms.DockStyle]::Fill
#$MyDMHRichTextBox.EnableAutoDragDrop = $False
#$MyDMHRichTextBox.Enabled = $True
$MyDMHRichTextBox.Font = $MyDMHConfig.FontData.Regular
$MyDMHRichTextBox.ForeColor = $MyDMHColor.TextForeColor
#$MyDMHRichTextBox.Height = 96
#$MyDMHRichTextBox.HideSelection = $True
#$MyDMHRichTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
#$MyDMHRichTextBox.IsAccessible = $False
#$MyDMHRichTextBox.LanguageOption = [System.Windows.Forms.RichTextBoxLanguageOptions]::AutoFont, DualFont
#$MyDMHRichTextBox.Left = 0
#$MyDMHRichTextBox.Lines = @()
#$MyDMHRichTextBox.Location = New-Object -TypeName System.Drawing.Point($MyDMHConfig.FormSpacer, $MyDMHConfig.FormSpacer)
#$MyDMHRichTextBox.Margin = New-Object -TypeName System.Windows.Forms.Padding(3, 3, 3, 3)
#$MyDMHRichTextBox.MaximumSize = New-Object -TypeName System.Drawing.Size(0, 0)
#$MyDMHRichTextBox.MaxLength = 2147483647
#$MyDMHRichTextBox.MinimumSize = New-Object -TypeName System.Drawing.Size(0, 0)
#$MyDMHRichTextBox.Modified = $False
#$MyDMHRichTextBox.Multiline = $True
$MyDMHRichTextBox.Name = "MyDMHRichTextBox"
#$MyDMHRichTextBox.Padding = New-Object -TypeName System.Windows.Forms.Padding(0, 0, 0, 0)
#$MyDMHRichTextBox.Parent = System.Windows.Forms.Control
#$MyDMHRichTextBox.ReadOnly = $False
#$MyDMHRichTextBox.Region = System.Drawing.Region
#$MyDMHRichTextBox.RichTextShortcutsEnabled = $True
#$MyDMHRichTextBox.RightMargin = 0
#$MyDMHRichTextBox.RightToLeft = [System.Windows.Forms.RightToLeft]::No
#$MyDMHRichTextBox.Rtf = "{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}\viewkind4\uc1\pard\f0\fs17\par}"
#$MyDMHRichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
#$MyDMHRichTextBox.SelectedRtf = "{\rtf1\ansi\ansicpg1252\deff0\deflang1033\uc1}"
#$MyDMHRichTextBox.SelectedText = ""
#$MyDMHRichTextBox.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left
#$MyDMHRichTextBox.SelectionBullet = $False
#$MyDMHRichTextBox.SelectionCharOffset = 0
$MyDMHRichTextBox.SelectionFont = $MyDMHConfig.FontData.Regular
#$MyDMHRichTextBox.SelectionHangingIndent = 0
#$MyDMHRichTextBox.SelectionIndent = 0
#$MyDMHRichTextBox.SelectionLength = 0
#$MyDMHRichTextBox.SelectionProtected = $False
#$MyDMHRichTextBox.SelectionRightIndent = 0
#$MyDMHRichTextBox.SelectionStart = 0
#$MyDMHRichTextBox.SelectionTabs = @()
#$MyDMHRichTextBox.ShortcutsEnabled = $True
#$MyDMHRichTextBox.ShowSelectionMargin = $False
#$MyDMHRichTextBox.Site = System.ComponentModel.ISite
#$MyDMHRichTextBox.Size = New-Object -TypeName System.Drawing.Size(100, 96)
#$MyDMHRichTextBox.TabIndex = 0
#$MyDMHRichTextBox.TabStop = $True
#$MyDMHRichTextBox.Tag = $Null
$MyDMHRichTextBox.Text = "MyDMHRichTextBox"
#$MyDMHRichTextBox.Top = 0
#$MyDMHRichTextBox.UseWaitCursor = $False
#$MyDMHRichTextBox.Visible = $True
#$MyDMHRichTextBox.Width = 100
#$MyDMHRichTextBox.WindowTarget = System.Windows.Forms.IWindowTarget
#$MyDMHRichTextBox.WordWrap = $True
#$MyDMHRichTextBox.ZoomFactor = 1
#endregion
$MyDMHToolTip.SetToolTip($MyDMHRichTextBox, "Help for Control $($MyDMHRichTextBox.Name)")



#region $MyDMHMenuStrip = System.Windows.Forms.MenuStrip
Write-Verbose -Message "Creating Form Control `$MyDMHMenuStrip"
$MyDMHMenuStrip = New-Object -TypeName System.Windows.Forms.MenuStrip
$MyDMHForm.Controls.Add($MyDMHMenuStrip)
$MyDMHForm.MainMenuStrip = $MyDMHMenuStrip
$MyDMHMenuStrip.BackColor = $MyDMHColor.BackColor
$MyDMHMenuStrip.Dock = [System.Windows.Forms.DockStyle]::Left
$MyDMHMenuStrip.Font = $MyDMHConfig.FontData.Regular
$MyDMHMenuStrip.ForeColor = $MyDMHColor.ForeColor
$MyDMHMenuStrip.Location = New-Object -TypeName System.Drawing.Point($MyDMHConfig.FormSpacer, $MyDMHConfig.FormSpacer)
$MyDMHMenuStrip.Name = "MyDMHMenuStrip"
#$MyDMHMenuStrip.ShowItemToolTips = $False
#$MyDMHMenuStrip.TabIndex = 0
#$MyDMHMenuStrip.TabStop = $False
#$MyDMHMenuStrip.Tag = $Null
$MyDMHMenuStrip.Text = "MyDMHMenuStrip"
$MyDMHMenuStrip.TextDirection = [System.Windows.Forms.ToolStripTextDirection]::Horizontal
#$MyDMHMenuStrip.Top = 0
#$MyDMHMenuStrip.UseWaitCursor = $False
#$MyDMHMenuStrip.Visible = $True
#$MyDMHMenuStrip.WindowTarget = System.Windows.Forms.IWindowTarget
#endregion

#region ******** $MyDMHMenuStrip MenuStrip MenuItems ********

#region function Start-MyDMHToolStripButtonClick
function Start-MyDMHToolStripButtonClick()
{
  <#
    .SYNOPSIS
      Click event for the MyDMHToolStripButton Control
    .DESCRIPTION
      Click event for the MyDMHToolStripButton Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDMHToolStripButtonClick -Sender $Sender -EventArg $EventArg
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
  Write-Verbose -Message "Enter Click Event for `$MyDMHToolStripButton"
  Try
  {
    $MyDMHConfig.AutoExit = 0
    #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    Switch ($Sender.Name)
    {
      "Close"
      {
        $MyDMHForm.Close()
        Break
      }
    }
    #$MyDMHForm.Cursor = [System.Windows.Forms.Cursors]::Arrow

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
  }
  Catch
  {
    Write-Debug -Message "ErrMsg: $($Error[0].Exception.Message)"
    Write-Debug -Message "Line: $($Error[0].InvocationInfo.ScriptLineNumber)"
    Write-Debug -Message "Code: $(($Error[0].InvocationInfo.Line).Trim())"
  }
  Write-Verbose -Message "Exit Click Event for `$MyDMHToolStripButton"
}
#endregion function Start-MyDMHToolStripButtonClick
#$MyDMHToolStripButton.add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
#(New-MenuItem -Menu $MyDMHMenuStrip -Text "Text" -Tag "Tag" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
#$NewMenuItem = New-MenuItem -Menu $MyDMHMenuStrip -Text "Text" -Tag "Tag" -PassThru
#$NewMenuItem.add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})

New-MenuSeparator -Menu $MyDMHMenuStrip
New-MenuLabel -Menu $MyDMHMenuStrip -Text "Help Menu" -FontStyle "Bold" -ForeColor "Yellow"
New-MenuSeparator -Menu $MyDMHMenuStrip

(New-MenuItem -Menu $MyDMHMenuStrip -Name "Introduction" -Text "Introduction" -Tag "Introduction" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMHMenuStrip -Name "Menu" -Text "Desktop Menu" -Tag "Menu" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
(New-MenuItem -Menu $MyDMHMenuStrip -Name "Command" -Text "Menu Command" -Tag "Command" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
New-MenuSeparator -Menu $MyDMHMenuStrip
(New-MenuItem -Menu $MyDMHMenuStrip -Name "Close" -Text "Close" -Tag "Close" -Alignment "MiddleLeft" -PassThru).add_Click({Start-MyDMHToolStripButtonClick -Sender $This -EventArg $PSItem})
New-MenuSeparator -Menu $MyDMHMenuStrip

#endregion ******** $MyDMHMenuStrip MenuStrip MenuItems ********




#region $MyDMHTopPanel = System.Windows.Forms.Panel
Write-Verbose -Message "Creating Form Control `$MyDMHTopPanel"
$MyDMHTopPanel = New-Object -TypeName System.Windows.Forms.Panel
$MyDMHForm.Controls.Add($MyDMHTopPanel)
$MyDMHTopPanel.BackColor = $MyDMHColor.BackColor
$MyDMHTopPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$MyDMHTopPanel.ForeColor = $MyDMHColor.ForeColor
$MyDMHTopPanel.Name = "MyDMHTopPanel"
$MyDMHTopPanel.Text = "MyDMHTopPanel"
#endregion

#region ******** $MyDMHTopPanel Controls ********

#region $MyDMHTopLabel = System.Windows.Forms.Label
Write-Verbose -Message "Creating Form Control `$MyDMHTopLabel"
$MyDMHTopLabel = New-Object -TypeName System.Windows.Forms.Label
$MyDMHTopPanel.Controls.Add($MyDMHTopLabel)
#$MyDMHTopLabel.AccessibleDefaultActionDescription = ""
#$MyDMHTopLabel.AccessibleDescription = ""
#$MyDMHTopLabel.AccessibleName = ""
#$MyDMHTopLabel.AccessibleRole = [System.Windows.Forms.AccessibleRole]::Default
#$MyDMHTopLabel.AllowDrop = $False
#$MyDMHTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")
$MyDMHTopLabel.BackColor = $MyDMHColor.TitleBackColor
$MyDMHTopLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
#$MyDMHTopLabel.Dock = [System.Windows.Forms.DockStyle]::None
$MyDMHTopLabel.Font = New-Object -TypeName System.Drawing.Font($MyDMHConfig.FontFamily, ($MyDMHConfig.FontSize * 1.5), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
$MyDMHTopLabel.ForeColor = $MyDMHColor.TitleForeColor
$MyDMHTopLabel.Location = New-Object -TypeName System.Drawing.Point(($MyDMHConfig.FormSpacer / 1), ($MyDMHConfig.FormSpacer / 1))
$MyDMHTopLabel.Name = "MyDMHTopLabel"
$MyDMHTopLabel.Text = $Title
$MyDMHTopLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#endregion
$MyDMHTopLabel.Size = New-Object -TypeName System.Drawing.Size(($MyDMHTopPanel.ClientSize.Width - ($MyDMHConfig.FormSpacer * 2)), $MyDMHTopLabel.PreferredHeight)
  
$MyDMHTopPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Right + ($MyDMHConfig.FormSpacer / 1)), ($($MyDMHTopPanel.Controls[$MyDMHTopPanel.Controls.Count - 1]).Bottom + ($MyDMHConfig.FormSpacer / 1)))

$MyDMHTopLabel.Anchor = [System.Windows.Forms.AnchorStyles]("Top", "Left", "Bottom", "Right")

#endregion ******** $MyDMHTopPanel Controls ********



#$MyDMHForm.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Right + $MyDMHConfig.FormSpacer), ($($MyDMHForm.Controls[$MyDMHForm.Controls.Count - 1]).Bottom + $MyDMHConfig.FormSpacer))

#endregion ******** $MyDMHForm Controls ********

#endregion ******** $MyDMHForm ********

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($MyDMHForm)

$MyDMHFormComponents.Dispose()
$MyDMHForm.Dispose()

if ($MyDMHConfig.Production)
{
  [Environment]::Exit(0)
}








