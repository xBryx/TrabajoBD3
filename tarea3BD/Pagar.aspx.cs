using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Pagar : System.Web.UI.Page
    {
        SqlConnection conexion;
        List<string> idFactura = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            var datos = Cache["numPropiedadSeleccionada"];
            Response.Write($"Propiedad seleccionada: {datos}");

            String sConexion = System.Configuration.ConfigurationManager.ConnectionStrings["cadenaconexion"].ConnectionString;            
            conexion = new SqlConnection(sConexion);
            conexion.Open();
            //SP
            SqlCommand cmd = new SqlCommand("sp_Factura_A_Cobrar", conexion);
            cmd.CommandType = CommandType.StoredProcedure;
            //Parametros de entrada SP
            cmd.Parameters.AddWithValue("@inNumFinca", datos);
            DataTable dt = crearDTCobros(cmd);
            pagosGV.DataSource = dt;
            pagosGV.DataBind();

        }

        //Crea un DataTable para mostrar en la interfaz.
        public DataTable crearDTCobros(SqlCommand cmd)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ConceptoCobro");
            dt.Columns.Add("FechaFacturacion");
            dt.Columns.Add("FechaVence");
            dt.Columns.Add("TotalOriginal");
            dt.Columns.Add("TotalFinal");

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                dt.Rows.Add(reader["ConceptoCobro"], reader["FechaFacturacion"], reader["FechaVence"],
                            reader["TotalOriginal"], reader["TotalFinal"]);
                idFactura.Add(reader["idFactura"].ToString());               
            }
            reader.Close();
            return dt;
        }

        protected void propiedadesGVRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Ver")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                string idFacturaPagar = idFactura[index];
                var datos = Cache["numPropiedadSeleccionada"];
                //SP
                SqlCommand cmd = new SqlCommand("sp_Pagar", conexion);
                cmd.CommandType = CommandType.StoredProcedure;
                //Parametros de entrada SP
                cmd.Parameters.AddWithValue("@inNumFinca", datos);
                cmd.Parameters.AddWithValue("@inIdFactura", idFacturaPagar);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    lblMensajePago.Text = $"El pago se realizó correctamente.<br/>" +
                          $"Día: <b>{reader["Fecha"]}</b><br/>" +
                          $"Monto: <b>{reader["Monto"]}</b> colones </b><br/>" +
                          $"Referencia: <b>{reader["Referencia"]} </b><br/>";                   
                }
                // Ejecutar JavaScript para abrir el modal
                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
                    "abrirModal",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalPagoHecho')); myModal.show();",
                    true
                );
                //Response.Redirect("Pagar.aspx");
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("Index.aspx");            
        }
        
        protected void btnCerrarModal_Click(object sender, EventArgs e)
        {
            Response.Redirect("Pagar.aspx");
        }
    }
}