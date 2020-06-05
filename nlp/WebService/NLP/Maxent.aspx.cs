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
    public partial class Maxent : System.Web.UI.Page
    {

        [DllImport("Maxent.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        static extern void Maxent_Colse(string model_name);

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Response.Expires = 0;
            string f = this.Request.QueryString["d"];
            if (!string.IsNullOrEmpty(f))
            {
                string name = Server.MapPath("/model/mm/") + f;
                if (File.Exists(name))
                {
                    Maxent_Colse(name);
                    File.Delete(name);
                }
                this.Response.Redirect("Maxent.aspx");
            }
            if (!this.IsPostBack)
            {
                LoadData();
            }
        }

        void LoadData()
        {
            DirectoryInfo dir = new DirectoryInfo(Server.MapPath("/model/mm/"));
            FileInfo[] fis = dir.GetFiles();
            foreach (FileInfo fi in fis)
            {
                HtmlTableRow tr = new HtmlTableRow();
                this.data.Rows.Insert(1,tr);
                HtmlTableCell td = new HtmlTableCell();
                td.InnerText = fi.Name;
                tr.Cells.Add(td);
                td = new HtmlTableCell();
                td.InnerHtml = string.Format("<a href=\"Maxent.aspx?d={0}\">删除</a>", fi.Name);
                tr.Cells.Add(td);
            }
        }

        protected void btnUp_Click(object sender, EventArgs e)
        {
            try
            {
                string file = Server.MapPath("/model/mm/") + DateTime.Now.ToString("yyyy-MM-dd_HH_mm_ss");
                this.FileUpload1.PostedFile.SaveAs(file);
                LoadData();
            }
            catch
            {
            }
        }
    }
}