# Little Esty Shop

### **Description**
---
"Little Esty Shop" is a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

### **Collaborators**
---
- [Axel De La Guardia](https://github.com/axeldelaguardia)
- [Brian Hayes](https://github.com/Bphayes1200)
- [Jasmine Hamou](https://github.com/hamouj)
- [Meredith Trevino](https://github.com/MATrevino)

### **Work Completed**
---
- Implemented FactoryBot and Faker to support testing
- Utilized ActiveRecord joins, aggregates, and grouping to fulfill user story functionality
- Incorporated data from GitHub REST API
- Completed all user stories
- Employed and maintained a GitHub project board to track progress
- Deployed application to Heroku

### **Future Iterations**
---
1. Determine how to break a tie for any top-5 model methods with associated edge testing.
1. Make a module for similar model methods.
1. Incorporate flash messaging for merchant items edit and new pages, including the needed validations within the model.


### **Questions**
---
1. For the merchant items and merchant invoices user stories, we decided to nest the items controller within a merchant folder and have the route point to the merchant/items and merchant/invoices controllers. Is this approach RESTful? If not, what would be a more RESTful approach?
