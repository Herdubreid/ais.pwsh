# Parse Shopping List with date variable
@"
Date 1/10
300g bread 4.20
150g butter 6.50
400g yogurt 7.20
120g ham 4.60
400g coffee 8.00
6 500ml beer 16.00
Date $date
100g This will not parse
300g bread 4.20
150g ham 5.10
6 480g eggs 4.80
200ml Date 5/10
Nor will this
6 500ml beer 16.00
250g baked beans 3.00
Date 6/10
300g bread 4.20
120g ham 4.70
"@
