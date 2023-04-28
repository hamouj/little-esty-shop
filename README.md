# Shop Spot

### **Description**
---
Shop Spot is a fictitious e-commerce platform where merchants and admins can manage inventory, fulfill customer invoices, as well as create, update, and delete bulk discounts.

### **Set-Up**
---
Fork and clone the repository

In the command line:
- Run `bundle`
- Run `rails csv_load:all`

To run the application:
- Run `rails s` in the command line
- Open a browser tab and visit localhost:3000

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
