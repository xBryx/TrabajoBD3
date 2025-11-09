using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Login : System.Web.UI.Page
    {
        String Mensaje;
        SqlConnection conexion;
        protected void Page_Load(object sender, EventArgs e)
        {
            String sConexion = System.Configuration.ConfigurationManager.ConnectionStrings["cadenaconexion"].ConnectionString;
            conexion = new SqlConnection(sConexion);

        }

        //Realiza el proceso para entrar a la interfaz principal de la web
        protected void btnEntrar_Click(object sender, EventArgs e)
        {
            String username = txtUsuario.Text;
            String password = txtContrasena.Text;
            //Validar datos de usuario
            if(username== ""  || password == "") { divInfoLogin.InnerText ="No se aceptan nulos";
                    return; }
            if (!validarDatosUsuario(username, password)) return;
            
            //Conexion SQL, ejecución de sp y agregar parametros
            conexion.Open();
            SqlCommand cmd = new SqlCommand("sp_Login", conexion);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@inUsername", username);
            cmd.Parameters.AddWithValue("@inPassword", password);
            //Parametro de retorno
            SqlParameter returnParam = new SqlParameter();
            returnParam.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(returnParam);            

            SqlDataReader reader = cmd.ExecuteReader();
            //int result = (int)returnParam.Value;
            //Leer datos del store procedure            
            if (!reader.Read())
            { //Si no hay mensaje de error
                var usuario = new
                {
                    Nombre = username,
                    Password = password,
                    IP = ipTextBox.Text
                };
                //Crear token
                string token = Guid.NewGuid().ToString();
                Cache.Insert("datosUsuario", usuario, null, DateTime.Now.AddMinutes(28), TimeSpan.Zero);
                Response.Redirect("Index.aspx");               
            }
            else
            {
               divInfoLogin.InnerText = (reader["Descripcion"]).ToString();
                
            }

            //Objeto con los datos del usuario

        }


        //Valida que los parametros recibidos sean letras o números dependiendo del caso
        //Escribe en el div Info el motivo del error
        public bool validarDatosUsuario(String username, String UsuarioPassword)
        {
            if (!Regex.IsMatch(username, "^[A-Za-z]+$"))
            {
                divInfoLogin.InnerText = "Solo letras en nombre de usuario";
                return false;
            }
            if (!Regex.IsMatch(UsuarioPassword, "^[0-9]+$"))
            {
                divInfoLogin.InnerText = "Solo inserte números en su contraseña";
                return false;
            }
            return true;

        }   
    }
}