<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="tarea3BD.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body>

    <form id="form1" runat="server">
        <div class="d-flex justify-content-center align-items-center vh-100 bg-light">
            <div class="p-4 border rounded bg-white shadow" style="width: 380px;">
                <h4 class="text-center mb-4">Iniciar sesión</h4>

                <div class="mb-3">
                    <label for="txtUsuario" class="form-label">Usuario</label>
                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label for="txtContrasena" class="form-label">Contraseña</label>
                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control" TextMode="Password" />
                </div>
                <asp:TextBox ID="ipTextBox" type="hidden" runat="server"/>
                <!--Codigo JS para obtener IP-->
                <script>
                    //Proceso para obtener la ip
                    fetch('https://api.ipify.org?format=json')
                        .then(res => res.json())
                        .then(data => {
                            //document.getElementById('ip').textContent = data.ip;
                            console.log("Tu IP es:", data.ip);
                            document.getElementById('ipTextBox').value = data.ip;
                        })
                        .catch(err => console.error("Error obteniendo IP:", err));
                </script>

                <asp:Button ID="btnEntrar" runat="server" Text="Entrar" CssClass="btn btn-primary w-100" OnClick="btnEntrar_Click" />
            </div>
        </div>
    </form>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



