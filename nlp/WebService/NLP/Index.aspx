<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="NLP.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>模型管理</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <a href="Maxent.aspx" target="_blank">最大熵</a><br/>
        <a href="CRF.aspx" target="_blank">条件随机场</a><br/>
        <a href="WebService.asmx" target="_blank">Web服务</a>
        <br />
        <label>crf 测试数据:Confidence NN$in IN$the DT$pound NN$is VBZ$widely RB</label><br/>
        <label>最大熵测试数据:f20 f30 f41 f50 f60 f70 f81 f91 f101 f111 f120 f130 f140 f151 f160 f170</label>
    </div>
    </form>
</body>
</html>
