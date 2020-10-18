﻿SetWorkingDir %A_ScriptDir%
Process,Exist, clash-win64.exe ;                         
if ErrorLevel
{   
}
else
{
    RunWait, ahkstart.bat,,Hide
    Sleep, 2200
}
programName:="ClashWeb By Nico"
Menu, Tray, NoStandard
Menu, Tray, Icon, clash-logo.ico,1,1
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.'
Menu, tray, Add, 切换节点, MenuHandlerdashboard
Menu, tray, Add, 更新配置, updateconfig
Menu, tray, Add, 配置管理, SetConfig

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu, Add, 启动, startclash
Menu, Submenu, Add, 关闭, stopclash
Menu, tray, add, 普通模式, :Submenu  
Menu, Submenu4, Add, 启动, tapstart
Menu, Submenu4, Add, 关闭, tapstop
Menu, Submenu4, Add  ; 创建分隔线.
Menu, Submenu4, Add  ; 创建分隔线.
Menu, Submenu4, Add, 安装网卡, installtap
Menu, Submenu4, Add, 卸载网卡, unstalltap
Menu, tray, add, Tap模式, :Submenu4  

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu3, Add, 规则, rulemode  
Menu, Submenu3, Add, 全局, globalmode
Menu, Submenu3, Add, 直连, directmode
Menu, tray, add, 代理模式, :Submenu3 
Menu, Submenu2, Add, 开启系统代理, setsys  
Menu, Submenu2, Add, 关闭系统代理, dissys
Menu, tray, add, 系统代理, :Submenu2

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu6, Add  ; 
Menu, Submenu5, Add, 打开控制台, clashweb 
Menu, Submenu5, Add, 关闭控制台, MenuHandlerstoppython  
Menu, Submenu6, add, 控制后台, :Submenu5
Menu, Submenu6, Add, 面板设置, defaultdashboard 
Menu, Submenu6, Add, 内核设置, defautlcore 
Menu, Submenu6, Add, Geoip设置, defaultgeoip
Menu, Submenu6, Add  ; 
Menu, Submenu6, Add, 控制后台端口, defautlclashwebpoart
Menu, Submenu6, Add, 默认系统代理, defautlsys
Menu, Submenu6, Add, 开机自启设置, bootset
Menu, Submenu6, Add  ; 
Menu, Submenu6, Add, UWP回环, uwp
Menu, Submenu6, Add, 帮助/捐赠, help
Menu, Submenu6, Add  ; 
Menu, tray, add, 其他设置, :Submenu6
Menu, Tray, Click, OnClick 
Menu, Tray, Add, 检查状态, OnClick
Menu, Tray, Add, 退出, MenuHandlerexit  
Menu, Tray, Default, 检查状态
Menu, Tray, Add  ; 创建分隔线.
Menu,Tray,Tip,%programName% 

OnClick:                                      ;任务栏图标双击单击效果
if !LastClick 
{
        LastClick := 1
        SetTimer,SingleClickEvent,-200
}
else if (LastClick = 1 )
{
        SetTimer,SingleClickEvent,off
        LastClick := 2
        SetTimer,DoubleClickEvent,-500
}
else if (LastClick = 2 )
{
        SetTimer,DoubleClickEvent,off
        gosub,TripleClickEvent
}
return

SingleClickEvent:
LastClick := 0
Goto, MenuHandlercheck 
return

DoubleClickEvent:
LastClick := 0
Goto, MenuHandlerdashboard
return

TripleClickEvent:
LastClick := 0
Goto, savenode
return

bootset:
RunWait,  %A_ScriptDir%\App\startup1.bat
return

uwp:
RunWait,  %A_ScriptDir%\bat\uwp.bat,,Hide
return

defaultgeoip:
MsgBox, 3,, "是"：原版geoip`n"否"：ipip版geoip
IfMsgBox, No
    Goto, ipipgeoip
IfMsgBox, Yes
    Goto, geoip
return

defaultdashboard:
MsgBox, 3,, "是"：Razord面板`n"否"：Yacd面板
IfMsgBox, No
    IniWrite, yacd, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
IfMsgBox, Yes
    IniWrite, Razord, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
return

defautlsys:
MsgBox, 3,, "是"：普通模式启动Clash时开启系统代理`n"否"：普通模式启动Clash时不开启系统代理
IfMsgBox, No
    IniWrite, False, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash 
IfMsgBox, Yes
    IniWrite, True, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash  
return

defautlclashwebpoart:
InputBox, OutputVar2, 请输入控制后台端口号, , 140, 480
if ErrorLevel
    return
else
    IniWrite, %OutputVar2%, %A_ScriptDir%\api\default.ini, SET, clashweb
    TrayTip % Format("📢通知📢"),修改控制台端口成功，请重新打开控制台
    return

updateconfig:
RunWait, ahksave.bat,,Hide
FileDelete, %A_ScriptDir%\App\tmptmp.vbs
FileCopy, %A_ScriptDir%\App\tmp.vbs, %A_ScriptDir%\App\tmptmp.vbs
RunWait, ahkupdateconfig,,Hide
IniRead, ifsuccess, %A_ScriptDir%\api\default.ini, SET, configdownload
if (ifsuccess = "success")
{
    RunWait,ahkrestartconfig,,Hide
    TrayTip % Format("📢通知📢"),更新当前配置并重启操作完成！ 
}
else
{
    TrayTip % Format("📢通知📢"),下载失败
}
Return

defautlcore:
MsgBox, 3,, "是"：切换为64位内核`n"否"：切换为32位内核
IfMsgBox, Yes
{
    RunWait, %A_ScriptDir%\bat\stop.bat,,Hide
    FileDelete, %A_ScriptDir%\App\clash-win64.exe
    FileCopy, %A_ScriptDir%\App\clash64.exe, %A_ScriptDir%\App\clash-win64.exe
}
IfMsgBox, No
{
    RunWait, %A_ScriptDir%\bat\stop.bat,,Hide
    FileDelete, %A_ScriptDir%\App\clash-win64.exe
    FileCopy, %A_ScriptDir%\App\clash32.exe, %A_ScriptDir%\App\clash-win64.exe
}
return

help:
Run, %A_ScriptDir%\App\help.png
return

nothing:
return

Button添加:
Goto,Url
return

Url:
    Gui, Destroy
    Gui, Add, Text,, 订阅链接:
    Gui, Add, Edit,w500 vsubUrl
    Gui, Add, Text,, 配置名称(例如：nico.yaml):
    Gui, Add, Edit,w500 vsubName
    Gui, Add, Button, Default, 保存
    Gui, Show
return


Button保存:
    Gui, Submit
    If (subUrl <> "" And subName <> ""){
        FileDelete, %A_ScriptDir%\Profile\%subName%  
        FileAppend, #托管地址: , %A_ScriptDir%\Profile\%subName% , UTF-8  
        FileAppend, %subUrl% , %A_ScriptDir%\Profile\%subName%  
        FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%subName% 
        Gui, Destroy
        goto, SetConfig
    }
return

Button订阅转换:
Run, %A_ScriptDir%\Profile\sub-web\index.html
goto,SetConfig
return

Button打开目录:
Run, %A_ScriptDir%\Profile
return

Button查看:
Gui, Submit
Run, open "%A_ScriptDir%\Profile\%NameText%"
goto,SetConfig
return


Button修改:
    Gui, Submit
    Gui, Destroy
    Gui, Add, Text,, 所选配置
    Gui, Add,Edit, w500 va,%NameText%
    Gui, Add, Text,, 订阅地址
    Gui, Add,Edit, w500 vb,%Urltext%
    Gui, Add, Text,, 新的订阅，为空将保持不变
    Gui, Add, Edit,w500 vsubUrl
    Gui, Add, Text,, 新的名称(例如：nico.yaml)，为空将保持不变
    Gui, Add, Edit,w500 vsubName
    Gui, Add, Button, Default w80, 确认修改
    Gui, Add, Button, xp+90 yp w80, 订阅/转换
    Gui, Add, Button, xp+90 yp w80, 取消
    Gui, Show
return

Button订阅/转换:
Run, %A_ScriptDir%\Profile\sub-web\index.html
goto,Button修改
return

Button确认修改:
Gui, Submit
If (subUrl <> "" And subName <> ""){
    FileDelete, %A_ScriptDir%\Profile\%subName%  
    FileAppend, #托管地址: , %A_ScriptDir%\Profile\%subName% , UTF-8  
    FileAppend, %subUrl% , %A_ScriptDir%\Profile\%subName%  
    FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%subName% 
    Gui, Destroy
    goto, SetConfig
}
If (subUrl = "" And subName <> ""){
    FileDelete, %A_ScriptDir%\Profile\%subName%  
    FileAppend, #托管地址: , %A_ScriptDir%\Profile\%subName% , UTF-8  
    FileAppend, %b% , %A_ScriptDir%\Profile\%subName%  
    FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%subName% 
    Gui, Destroy
    goto, SetConfig
}
If (subUrl <> "" And subName = ""){
    FileDelete, %A_ScriptDir%\Profile\%a%  
    FileAppend, #托管地址: , %A_ScriptDir%\Profile\%a% , UTF-8  
    FileAppend, %subUrl% , %A_ScriptDir%\Profile\%a%  
    FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%a% 
    Gui, Destroy
    goto, SetConfig
}
return

Button更新:
Gui, Submit
RunWait, ahksave.bat,,Hide
FileDelete, %A_ScriptDir%\App\tmptmp.vbs  
var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
FileAppend, %var% , %A_ScriptDir%\App\tmptmp.vbs 
FileAppend, %NameText% , %A_ScriptDir%\App\tmptmp.vbs 
var := """,0"
FileAppend, %var% , %A_ScriptDir%\App\tmptmp.vbs  
RunWait, ahkupdateconfig.bat,,Hide
IniRead, ifsuccess, %A_ScriptDir%\api\default.ini, SET, configdownload
if (ifsuccess = "success")
{
    TrayTip % Format("📢通知📢"),更新成功 
    MsgBox, 4,,%NameText%更新成功，是否重启？
    IfMsgBox, Yes
    {
        FileDelete, %A_ScriptDir%\App\tmp.vbs  
        var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
        FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs 
        FileAppend, %NameText% , %A_ScriptDir%\App\tmp.vbs 
        var := """,0"
        FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs   
        Gui, Destroy
        RunWait, ahkrestartconfig.bat,,Hide
        TrayTip % Format("📢通知📢"),重启操作成功
        return
    }         
    goto,SetConfig    
}
else
{
    TrayTip % Format("📢通知📢"),下载失败
    goto,SetConfig
}

return


Button启动:
RunWait, ahksave.bat,,Hide
Gui, Submit
FileDelete, %A_ScriptDir%\App\tmp.vbs  
var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs 
FileAppend, %NameText% , %A_ScriptDir%\App\tmp.vbs 
var := """,0"
FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs   
Gui, Destroy
RunWait, ahkrestartconfig.bat,,Hide
TrayTip % Format("📢通知📢"),启动操作成功
return

Button删除:
Gui, Submit
MsgBox, 4,, 所选配置:%NameText%，是否删除
IfMsgBox, Yes
{
    NewStr := StrReplace(NameText, "yaml", "txt")
    FileDelete, %A_ScriptDir%\Profile\%NameText%
    FileDelete, %A_ScriptDir%\Profile\tapconfig\%NameText%
    FileDelete, %A_ScriptDir%\Profile\save\%NewStr%
} 
Gui, Destroy
goto, SetConfig
return

Button取消:
goto, SetConfig
return


SetConfig:
    Gui, Destroy
    Gui, Add, Text,, 双击配置文件进行下一步操作
    Gui, Add, ListView,r10 w800 Multi AltSubmit gSelectConfigs, 名称|更新日期|大小|订阅地址
    Gui, Add, Button, Default w80, 添加
    Gui, Add, Button, xp+100 yp w80, 订阅转换
    Gui, Add, Button, xp+100 yp w80, 打开目录
    Loop, Profile\*.yaml
    {
        FileReadLine, oUrl, %A_ScriptDir%\Profile\%A_LoopFileName%, 1
        cUrl := StrSplit(oUrl, ":http")
        cUrl := cUrl[2]
        cUrl := StrSplit(cUrl, "NicoNewBeee")
        cUrl := cUrl[1]
        cUrl =  http%cUrl%
        StringMid, monthmodi, A_LoopFileTimeModified, 5, 2
        StringMid, datemodi, A_LoopFileTimeModified, 7, 2
        StringMid, hourmodi, A_LoopFileTimeModified, 9, 2
        StringMid, minmodi, A_LoopFileTimeModified, 11, 2
        TimeModi = %monthmodi%/%datemodi% %hourmodi%:%minmodi%
        LV_Add("", A_LoopFileName, TimeModi, A_LoopFileSizeKB, cUrl) 
    } 
    LV_ModifyCol() ; 根据内容自动调整每列的大小.
    LV_ModifyCol(2,"100 Integer") ; 为了进行排序, 指出列 2 是整数.
    ; 显示窗口并返回. 每当用户点击一行时脚本会发出通知.
    Gui, Show
return

SelectConfigs:
    if A_GuiEvent = DoubleClick
    {
        LV_GetText(NameText, A_EventInfo) ; 从行的第一个字段中获取文本.
        LV_GetText(Urltext, A_EventInfo, 4)
        If (%A_EventInfo%<>0){
            Gui, Destroy
            Gui, Add, Text,, 所选文件：%NameText% 
            Gui, Add, Button, Default w80, 启动
            Gui, Add, Button, xp+90 yp w80, 更新
            Gui, Add, Button, xp+90 yp w80, 修改
            Gui, Add, Button, xp+90 yp w80, 查看
            Gui, Add, Button, xp+90 yp w80, 删除
            Gui, Add, Button, xp+90 yp w80, 取消
            Gui, Show
        }
    }
return


geoip:
RunWait, ahkgeoip.bat,,Hide
TrayTip % Format("📢通知📢"),更新切换成Geoip
return

ipipgeoip:
RunWait, ahkipip.bat,,Hide
TrayTip % Format("📢通知📢"),更新切换成IPIPgeoip
return

savenode:
RunWait, ahksave.bat,,Hide
TrayTip % Format("📢通知📢"),保存节点成功
return

installtap:
RunWait, %A_ScriptDir%\App\tap\ahkinstalltap.bat
TrayTip % Format("📢通知📢"),安装网卡操作成功
return

unstalltap:
FileGetSize, UninstallSize, C:\Program Files\TAP-Windows\Uninstall.exe, K
If UninstallSize
    RunWait, C:\Program Files\TAP-Windows\Uninstall.exe,,Hide
TrayTip % Format("📢通知📢"),卸载网卡操作成功
return

tapstart:
RunWait, ahkstopclashtap.bat,,Hide
RunWait, ahkstartclashtap.bat,,Hide
TrayTip % Format("📢通知📢"),Tap模式启动操作完成
return


tapstop:
RunWait, ahkstopclashtap.bat,,Hide
TrayTip % Format("📢通知📢"),Tap模式关闭操作完成
return

admin:
RunWait, ahkopenadmin.bat,,Hide
return

clashweb:
Run, ahkopenclashweb.bat,,Hide
return

setsys:
RunWait, %A_ScriptDir%\bat\setsys.bat,,Hide
Goto, checksys
return

dissys:
RunWait, %A_ScriptDir%\bat\dissys.bat,,Hide
Goto, checksys
return

checksys:
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),系统代理：%ProxyVar%
return

checkclash:
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
}
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    ClashVar := "关-❌"
}
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
return

checkpython:
Process,Exist, python.exe ; 
if ErrorLevel   
{
    PythonVar := "开-✅"
}
else
{ 
    PythonVar := "关-❌"
}

TrayTip % Format("📢运行状态📢"), 控制台：%PythonVar%
return


MenuHandlercheck:
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}

Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
}
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    ClashVar := "关-❌"
}
Process,Exist, python.exe ; 
if ErrorLevel   
{
    PythonVar := "开-✅"
}
else
{ 
    PythonVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"), 运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%`n控制  后台：%PythonVar%
return


stopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclash.bat,,Hide
TrayTip % Format("📢通知📢"),普通模式关闭操作完成
return

startclash:
RunWait, ahkrestartclash.bat,,Hide
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    TrayTip % Format("📢启动失败📢"),请用控制台重启，查看报错信息。
    return
}
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
}
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢启动成功📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
return

rulemode:
RunWait, ahkrule.bat,,Hide
TrayTip % Format("📢通知📢"),规则模式
return

directmode:
RunWait, ahkdirect.bat,,Hide
TrayTip % Format("📢通知📢"),直连模式
return

globalmode:
RunWait, ahkglobal.bat,,Hide
TrayTip % Format("📢通知📢"),全局模式
return

MenuHandlerupdateconfig:
RunWait, ahkupdateconfig.bat,,Hide
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    TrayTip % Format("📢重启失败📢"),请用控制台重启，查看报错信息。
    return
}
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
}
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢更新并重启成功📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
return


MenuHandlerstoppython:
MsgBox, 4,, 确定要关闭Python控制台吗 ? 关闭后网页控制台不可用 ！
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclashweb.bat,,Hide
Goto, checkpython
return


MenuHandlerdashboard:
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, defaultdashboard
    if (Dash = "Razord")
    {
        RunWait, ahkopendashboard.bat,,Hide
    }
    else
    {
        Run, %A_ScriptDir%\Profile\dashboard_%Dash%\index.html
    }
}
else
{
    ClashVar := "关-❌"
    TrayTip % Format("📢打开失败📢"),Clash：%ClashVar%`n请先启动Clash
}
return

MenuHandlerexit:
RunWait, ahkexit.bat,,Hide
ExitApp