<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Maxent.aspx.cs" Inherits="NLP.Maxent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>最大熵模型管理</title>

    <style>
        table,table tr th, table tr td { border:1px solid #0094ff; }
        table { width: 200px; min-height: 25px; line-height: 25px; text-align: center; border-collapse: collapse;}   
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin-left:auto; margin-right:auto; width:500px;">
            <asp:FileUpload ID="FileUpload1" runat="server" />
            <asp:Button ID="btnUp" runat="server" OnClick="btnUp_Click" Text="上传模型" />
            
            <table id="data" runat="server" style="width:500px; margin-top:10px;">
                <tr>
                    <td><strong>模型名称</strong></td><td><strong>删除</strong></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
