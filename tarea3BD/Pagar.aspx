<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Pagar.aspx.cs" Inherits="tarea3BD.Pagar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="text-center text-primary mb-4">Facturas a Pagar</h3>
    <div class="d-flex justify-content-center card shadow-lg p-4 bg-white rounded" style="min-width: 700px; max-height: 425px; overflow-y: auto;">
        <!--        <div style="width: 600px; height: 300px; overflow: auto;"> -->
        <asp:GridView ID="pagosGV" runat="server"
            CssClass="table table-hover table-striped align-middle text-center"
            HeaderStyle-CssClass="table-primary"
            BorderStyle="None"
            AutoGenerateColumns="False"
            OnRowCommand="propiedadesGVRowCommand">
            <columns>
                <asp:BoundField DataField="ConceptoCobro" HeaderText="Concepto Factura" />
                <asp:BoundField DataField="FechaFacturacion" HeaderText="Fecha Facturación" />
                <asp:BoundField DataField="FechaVence" HeaderText="Fecha Vencimiento" />
                <asp:BoundField DataField="TotalOriginal" HeaderText="Total (Sin intereses)" />
                <asp:BoundField DataField="TotalFinal" HeaderText="Total (Con intereses)" />
                <asp:ButtonField ButtonType="Button" Text="Pagar" CommandName="Ver" />
            </columns>
        </asp:GridView>
    </div>
    <div class="d-flex justify-content-center">
        <asp:Button class="btn btn-nvar me-2" ID="btnVolver" runat="server" Text="Volver" OnClick="btnVolver_Click"></asp:Button>
    </div>

</asp:Content>
