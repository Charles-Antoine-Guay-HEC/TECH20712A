/* Business Problem 2: 
Managers want to see which property features are most associated  
with client satisfaction. This helps identify what features drive positive ratings  
and therefore highlight those in marketing and listings.  
Here's a query that displays each feature along with the average rating of properties 
that include it.  
We show only the features where the average rating is greater than or equal to 4.  
*/ 

SELECT f.Feature,  
AVG(c.Rating) AS AvgRating,  
COUNT(c.CommentsID) AS TotalComments 
FROM Comments c 
JOIN Client cl ON c.ClientID = cl.ClientID 
JOIN Wishlist w ON cl.ClientID = w.ClientID 
JOIN WishlistFeature wlf ON wlf.WishlistID = w.WishlistID 
JOIN Feature f ON wlf.FeatureID = f.FeatureID 
GROUP BY f.Feature 
HAVING AVG(c.Rating) >= 4;  

/* Interpretation:  
This result highlights which features (like pools, garages, or fireplaces) are most linked to 
client satisfaction. Managers can emphasize these features in marketing and prioritize them 
in property improvements. 
*/