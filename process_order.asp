<%
    ' Declare variables
    Dim name, email, phone, address, totalPrice
    Dim pizzaNames, pizzaPrices
    Dim i, pizza, quantity, price, totalPriceForPizza
    Dim orderedPizzas, orderedQuantities
    
    ' Retrieve form data
    name = Request.Form("name")
    email = Request.Form("email")
    phone = Request.Form("phone")
    address = Request.Form("address")
    
    totalPrice = 0
    orderedPizzas = ""
    orderedQuantities = ""

    ' Define the available pizzas and their prices
    pizzaNames = Array("Pepperoni", "Cheese", "Veggie", "Chicken")
    pizzaPrices = Array(10, 8, 9, 12)
    
    ' Loop through each pizza selection
    For i = 0 To UBound(pizzaNames)
        pizza = pizzaNames(i)
        quantity = CInt(Request.Form("quantity_" & pizza)) ' Get the quantity of the current pizza

        ' Check if the pizza was selected (quantity > 0)
        If quantity > 0 Then
            price = pizzaPrices(i)
            totalPriceForPizza = price * quantity
            totalPrice = totalPrice + totalPriceForPizza
            
            ' Append pizza and quantity to the lists
            If Len(orderedPizzas) > 0 Then
                orderedPizzas = orderedPizzas & ", " & pizza
                orderedQuantities = orderedQuantities & ", " & CStr(quantity) ' Convert quantity to string
            Else
                orderedPizzas = pizza
                orderedQuantities = CStr(quantity) ' Convert first quantity to string
            End If
        End If
    Next
    
    ' Store order details in the database
    Set db = Server.CreateObject("ADODB.Connection")
    Set rs = Server.CreateObject("ADODB.Recordset")
    db.Provider = "Microsoft.ACE.OLEDB.12.0"
    db.Open "C:\Users\sony\Desktop\pizza hut\Database.accdb"
    rs.Open "PizzaOrders", db, 1, 3

    ' Add new order
    rs.AddNew
    rs("Name") = name
    rs("Email") = email
    rs("Phone") = phone
    rs("Address") = address
    rs("Pizza") = orderedPizzas ' Store all pizzas as a comma-separated string
    rs("quantity") = orderedQuantities ' Store all quantities as a comma-separated string
    rs("TotalPrice") = totalPrice ' Store the total price in the database
    rs.Update
    
    ' Close database connections
    rs.Close
    db.Close
    Set rs = Nothing
    Set db = Nothing
%>

<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="confirmation_css.css"> 
</head>
<body>
    <div class="container">
        <h1>Thank you for your order, <%=name%>!</h1>
        <h3>Order Summary</h3>
        <div class="details">
            <p><strong>Pizzas Ordered:</strong> <%=orderedPizzas%></p>
            <p><strong>Quantities:</strong> <%=orderedQuantities%></p>
            <p><strong>Total Price:</strong> $<%=totalPrice%></p>
            <p><strong>Delivery Address:</strong> <%=address%></p>
        </div>
    </div>
<!-- Go Back Button -->
<div class="back-button">
    <button onclick="history.back()">Go Back</button>
</div>
</body>
</html>
