<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="tarea3BD.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <div class="d-flex justify-content-center align-items-center vh-100 bg-light">
        <!--Centra todo el contenido-->


        <div class="card shadow-lg p-4 bg-white rounded" style="min-width: 700px; max-height: 400px; overflow-y: auto;">
            <h3 class="text-center text-primary mb-4">Lista de Propiedades</h3>

            <!--        <div style="width: 600px; height: 300px; overflow: auto;"> -->
            <asp:GridView ID="propiedadesGV" runat="server"
                CssClass="table table-hover table-striped align-middle text-center"
                HeaderStyle-CssClass="table-primary"
                BorderStyle="None"
                AutoGenerateColumns="False"
                OnRowCommand="propiedadesGVRowCommand">
                <Columns>
                    <asp:BoundField DataField="numPropiedad" HeaderText="Número Propiedad" />
                    <asp:BoundField DataField="nombrePropietario" HeaderText="Nombre" />
                    <asp:ButtonField ButtonType="Button" Text="Seleccionar" CommandName="Ver" />
                </Columns>
            </asp:GridView>
        </div>
        <br>
    </div>

    <div class="d-flex justify-content-center">
        <asp:Button class="btn btn-nvar me-2" ID="btnFacPen" runat="server" Text="Facturas Pendientes"></asp:Button>
        <asp:Button class="btn btn-nvar me-2" ID="btnFacPag" runat="server" Text="Facturas Pagadas"></asp:Button>
        <asp:Button class="btn btn-nvar me-2" ID="btnPagFac" runat="server" Text="Pagar Facturas"></asp:Button>

        <br>
    </div>
    <div class="d-flex justify-content-center">
        <br>
        <!--Agregar Dinamicamente los cobros que corresponden a un tipo especifico de propiedad-->
        <asp:ListBox ID="listaFacturas" runat="server" SelectionMode="Multiple" CssClass="form-control">
            <asp:ListItem Value="1">Agua</asp:ListItem>
            <asp:ListItem Value="2">Reconexión de agua</asp:ListItem>
            <asp:ListItem Value="3">Intereses Moratorios</asp:ListItem>
            <asp:ListItem Value="4">Impuesto sobre propiedad</asp:ListItem>
        </asp:ListBox>


        <br />
        <br />
        <asp:Button class="btn btn-nvar me-2" ID="btnPag" runat="server" Text="Pagar"></asp:Button>
    </div>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap4-multiselect/dist/css/bootstrap-multiselect.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap4-multiselect/dist/js/bootstrap-multiselect.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#<%= listaFacturas.ClientID %>').multiselect({
        includeSelectAllOption: true,
        nonSelectedText: 'Selecciona propiedades',
        allSelectedText: 'Todas seleccionadas',
        nSelectedText: 'seleccionadas',
        numberDisplayed: 2,
        buttonWidth: '300px'
    });
});
    </script>  
</asp:Content>
