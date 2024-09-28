# Assignment 1: Design a Logical Model

## Question 1
Create a logical model for a small bookstore. 📚

At the minimum it should have employee, order, sales, customer, and book entities (tables). Determine sensible column and table design based on what you know about these concepts. Keep it simple, but work out sensible relationships to keep tables reasonably sized. Include a date table. There are several tools online you can use, I'd recommend [_Draw.io_](https://www.drawio.com/) or [_LucidChart_](https://www.lucidchart.com/pages/).


Answer: below is the logical model for the bookstore:
![](images/Logical%20Model%20for%20a%20Bookstore_1.png)

## Question 2
We want to create employee shifts, splitting up the day into morning and evening. Add this to the ERD.

Answer: below is the logical model for the bookstore, with a employee shift table,in which the "shift_type" column specifies whether a shift is a morning shift or an evening shift.
![](images/Logical%20Model%20for%20a%20Bookstore_2.png)

## Question 3
The store wants to keep customer addresses. Propose two architectures for the CUSTOMER_ADDRESS table, one that will retain changes, and another that will overwrite. Which is type 1, which is type 2?

_Hint, search type 1 vs type 2 slowly changing dimensions._

Bonus: Are there privacy implications to this, why or why not?
```
Your answer...
```

Answer: 
The table which overwrites will be a Type 1 (see the 1st pic below) and the table which retain historical changes will be Type2  (see the 2nd pic below).

Regarding privacy implications: Yes, there are privacy concerns. An individual's address information is sensitive data and many people may not want retailers to retain their past address information for extended periods. There is risk of unauthorized access or misuse of personal information.  

Type1- only the latest address is kept
 ![](images/Logical%20Model%20for%20a%20Bookstore_3_Type1.png)
Type2- historical addresses are kept
 ![](images/Logical%20Model%20for%20a%20Bookstore_3_Type2.png)

 


## Question 4
Review the AdventureWorks Schema [here](https://i.stack.imgur.com/LMu4W.gif)

Highlight at least two differences between it and your ERD. Would you change anything in yours?
```
Your answer...
```

2 interesting differences:
First: The AdventureWorks categorizes all tables into 4 categories, according to the business process and functions: sales, production, purchase, person (regarding external persons in both purchase and sales), HumanResources (internal people and activities), dbo(on database management).
Second: The AdventureWorks collects and stores much richer and detailed information of the product, such as product description (in tables named ProductPhoto, ProductModel, ProductDescription, ProductCategory, ProductSubcategory, etc.).

Would you change anything in yours?
Yes, I’d like to group the tables in my ERD into 4 main categories: sales, purchase, book (product description and inventory) and employee management.This'd make the whole ERD clearer and easier to use.
Additionally, if with more understanding of the operation of the bookstore, I can add more tables and refine the columns and data categories in them (that is what data is valuable for collection and management).  


# Criteria

[Assignment Rubric](./assignment_rubric.md)

# Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `September 28, 2024`
* The branch name for your repo should be: `model-design`
* What to submit for this assignment:
    * This markdown (design_a_logical_model.md) should be populated.
    * Two Entity-Relationship Diagrams (preferably in a pdf, jpeg, png format).
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `model-design`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack at `#cohort-4-help`. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
