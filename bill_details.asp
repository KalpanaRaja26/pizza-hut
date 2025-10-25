<%
    ' Retrieve form data (email or phone number)
    Dim emailOrPhone
    emailOrPhone = Trim(LCase(Request.Form("emailOrPhone"))) ' Convert input to lowercase and trim spaces

    ' Declare database variables
    Dim db, rs
    Set db = Server.CreateObject("ADODB.Connection")
    Set rs = Server.CreateObject("ADODB.Recordset")
    db.Provider = "Microsoft.ACE.OLEDB.12.0"
    db.Open "C:\Users\sony\Desktop\pizza hut\Database.accdb"

    ' Open the PizzaOrders table
    rs.Open "PizzaOrders", db, 1, 3

    ' Initialize a flag to track if a matching order is found
    Dim orderFound
    orderFound = False

    ' Loop through all records in the PizzaOrders table
    Do While Not rs.EOF
        ' Retrieve current record's email and phone and process them
        Dim dbEmail, dbPhone
        dbEmail = Trim(LCase(rs("Email"))) ' Convert email from DB to lowercase and trim spaces
        dbPhone = Trim(LCase(rs("Phone"))) ' Convert phone from DB to lowercase and trim spaces

        ' Check if the current record's email or phone matches the input
        If dbEmail = emailOrPhone OR dbPhone = emailOrPhone Then
            ' Order found, retrieve and display the details
            Dim name, email, phone, pizzas, quantities, address, totalPrice
            name = rs("name")
            email = rs("Email")
            phone = rs("phone")
            pizzas = rs("pizza")
            quantities = rs("quantity")
            address = rs("address")
            totalPrice = rs("totalprice")

            orderFound = True ' Set the flag to true
            Exit Do ' Exit the loop once the matching order is found
        End If
        rs.MoveNext ' Move to the next record
    Loop

    ' Check if an order was found
    If orderFound Then
        ' Split the pizza names and quantities by commas
        Dim pizzaArray, quantityArray, i
        pizzaArray = Split(pizzas, ",") ' Split pizza names into an array
        quantityArray = Split(quantities, ",") ' Split quantities into an array
%>

<html>
<head>
    <title>Bill Details</title>
    <link rel="stylesheet" href="bill_details_css.css">
</head>
<body>
    <div class="container">
        <h1>Bill Details for <%=name%></h1>
        <table border="1" class="bill-table">
            <tr>
                <th>Email</th>
                <td><%=email%></td>
            </tr>
            <tr>
                <th>Phone</th>
                <td><%=phone%></td>
            </tr>
            <tr>
                <th>Delivery Address</th>
                <td><%=address%></td>
            </tr>
            <tr>
                <th>Total Price</th>
                <td>$<%=totalPrice%></td>
            </tr>
        </table>

        <h2>Pizzas Ordered</h2>
        <table border="1" class="pizza-table">
            <tr>
                <th>Pizza</th>
                <th>Quantity</th>
            </tr>
            <% 
            ' Loop through pizzas and quantities arrays
            For i = 0 To UBound(pizzaArray)
            %>
            <tr>
                <td><%=Trim(pizzaArray(i))%></td>
                <td><%=Trim(quantityArray(i))%></td>
            </tr>
            <% Next %>
        </table>
    </div>

    <!-- Go Back Button -->
    <div class="back-button">
        <button onclick="history.back()">Go Back</button>
    </div>
</body>
</html>

<%
    Else
        ' No order found
%>
<html>
<head>
    <title>No Order Found</title>
    <link rel="stylesheet" href="bill_details_css.css">
</head>
<body>
    <div class="container">
        <h1>No Order Found</h1>
        <p>We could not find an order with the provided email or phone number.</p>
    </div>
    <!-- Go Back Button -->
    <div class="back-button">
        <button onclick="history.back()">Go Back</button>
    </div>
</body>
</html>
<%
    End If

    ' Close the recordset and connection
    rs.Close
    db.Close
    Set rs = Nothing
    Set db = Nothing
%>
