The logical model of this database is based of a few assumptions of our own. 

First, we assume that a property could not be waterfront and waterview since a waterfront house meant also waterview.
So, we create a viewtype with a forein key in property to chose between type 0,1,2 (no view, waterview, waterfront).

Then, We linked the taxes reates directly with the countries and provinces to ensure that each house with its adress was affected the good rate. By doing that,the person entering the informations can not make a mistakes choosing the rate since its directly linked to the country and province.

Finally, because a client could sell more than one property and because a client could also be a seller, we added a clientpropertysale that let us identify which client is the seller for each property.