using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace NLP
{
    public partial class CRF : System.Web.UI.Page
    {
        [DllImport("CRF.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        static extern void CRF_Colse(string model_name);


        protected void Page_Load(object sender, EventArgs e)
        {
            this.Response.Expires = 0;
            string f = this.Request.QueryString["d"];
            if (!string.IsNullOrEmpty(f))
            {
                string name = Server.MapPath("/model/crf/") + f;
                if (File.Exists(name))
                {
                    CRF_Colse(name);
                    File.Delete(name);
                }
                this.Response.Redirect("CRF.aspx");
            }
            if (!this.IsPostBack)
            {
                LoadData();
            }
        }

        void LoadData()
        {
            DirectoryInfo dir = new DirectoryInfo(Server.MapPath("/model/crf/"));
            FileInfo[] fis = dir.GetFiles();
            foreach (FileInfo fi in fis)
            {
                HtmlTableRow tr = new HtmlTableRow();
                this.data.Rows.Insert(1, tr);
                HtmlTableCell td = new HtmlTableCell();
                td.InnerText = fi.Name;
                tr.Cells.Add(td);
                td = new HtmlTableCell();
                td.InnerHtml = string.Format("<a href=\"CRF.aspx?d={0}\">删除</a>", fi.Name);
                tr.Cells.Add(td);
            }
        }

        protected void btnUp_Click(object sender, EventArgs e)
        {
            try
            {
                string file = Server.MapPath("/model/crf/") + DateTime.Now.ToString("yyyy-MM-dd_HH_mm_ss");
                this.FileUpload1.PostedFile.SaveAs(file);
                LoadData();
            }
            catch
            {
            }
        }
    }
}