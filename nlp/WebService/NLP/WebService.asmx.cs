using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;
using System.Web.Services;

namespace NLP
{
    /// <summary>
    /// WebService 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        //CharSet = CharSet.Ansi, @"D:\NLP\NLP\NLP\bin\Maxent.dll"
        //[DllImport("Maxent.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "Maxent")]
        [DllImport("Maxent.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "Maxent")]
        static extern int maxent(string model_name, string str_in, StringBuilder str_out, int len);

        static object lock_mm = new object(); 

        [WebMethod]
        public string Maxent(string model, string str)
        {
            lock (lock_mm)
            {
                model = Server.MapPath("/model/mm/") + model;
                if (System.IO.File.Exists(model))
                {
                    int len = 100;// str.Length * 2 + 1;
                    StringBuilder sb = new StringBuilder(len);
                    int c = maxent(model, str, sb, len);
                    return sb.ToString();
                }
                else
                {
                    return "模型文件不存在";
                }
            }
        }


        [DllImport("CRF.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi,EntryPoint = "CRF")]
        static extern int crf(string model_name, string str_in, StringBuilder str_out, int len);


        static object lock_crf = new object();

        [WebMethod]
        public string CRF_test(string model, string str)
        {
            str = str.Replace("$", "\n");
            return CRF(model,str);
        }

        [WebMethod]
        public string CRF(string model, string str)
        {
            //str = "Confidence NN\nin IN\nthe DT\npound NN\nis VBZ\nwidely RB\n";
            lock (lock_crf)
            {
                model = Server.MapPath("/model/crf/") + model;
                if (System.IO.File.Exists(model))
                {
                    int len = str.Length * 2 + 1;
                    if (str.Length == 0)
                    {
                        return "请录入字符串";
                    }
                    StringBuilder sb = new StringBuilder(len);
                    int c = crf(model, str, sb, len);
                    return sb.ToString();
                }
                else
                {
                    return "模型文件不存在";
                }
            }
        }

    }
}
