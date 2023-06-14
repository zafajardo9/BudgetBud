final List<String> incomeCategories = [
  'Employment Income',
  'Self-Employment Income',
  'Rental Income',
  'Investment Income',
  'Retirement Income',
  'Social Security Income',
  'Royalties',
  'Commission Income',
  'Bonus Income',
  'Alimony/Child Support',
  'Lottery/Gambling Winnings',
  'Capital Gains',
  'Rental Property Income',
  'Dividend Income',
  'Annuity Payments',
];

final List<String> expenseCategories = [
  'Housing Expenses',
  'Utilities',
  'Transportation Expenses',
  'Food and Groceries',
  'Health and Medical Expenses',
  'Debt Payments',
  'Personal Care',
  'Education Expenses',
  'Entertainment',
  'Clothing and Accessories',
  'Insurance Premiums',
  'Savings and Investments',
  'Charitable Donations',
  'Travel Expenses',
  'Home Maintenance',
];

final List<Map<String, String>> incomeCategoriesWithDescrip = [
  {
    'category': 'Employment Income',
    'description': 'Income received from employment or salary.'
  },
  {
    'category': 'Self-Employment Income',
    'description':
        'Income earned from running your own business or being a freelancer.'
  },
  {
    'category': 'Rental Income',
    'description': 'Income generated from renting out properties or assets.'
  },
  {
    'category': 'Investment Income',
    'description':
        'Income earned from investments such as stocks, bonds, or real estate.'
  },
  {
    'category': 'Retirement Income',
    'description':
        'Income received after retirement, often from pensions or retirement accounts.'
  },
  {
    'category': 'Social Security Income',
    'description': 'Income received from social security benefits.'
  },
  {
    'category': 'Royalties',
    'description':
        'Income received as royalties for the use of intellectual property or creative works.'
  },
  {
    'category': 'Commission Income',
    'description':
        'Income earned based on a percentage of sales or transactions.'
  },
  {
    'category': 'Bonus Income',
    'description': 'Additional income received as a bonus or incentive.'
  },
  {
    'category': 'Alimony/Child Support',
    'description': 'Income received as alimony or child support payments.'
  },
  {
    'category': 'Lottery/Gambling Winnings',
    'description':
        'Income received from winning lotteries or gambling activities.'
  },
  {
    'category': 'Capital Gains',
    'description':
        'Income generated from the sale of assets, such as stocks or real estate.'
  },
  {
    'category': 'Rental Property Income',
    'description':
        'Income generated from renting out a specific property or real estate.'
  },
  {
    'category': 'Dividend Income',
    'description':
        'Income received as dividends from investments in stocks or mutual funds.'
  },
  {
    'category': 'Annuity Payments',
    'description':
        'Income received as regular payments from an annuity contract.'
  },
];

final List<Map<String, String>> expenseCategoriesWithDescrip = [
  {
    'category': 'Housing Expenses',
    'description':
        'Expenses related to housing, including rent or mortgage payments, property taxes, and maintenance costs.'
  },
  {
    'category': 'Utilities',
    'description':
        'Expenses for utilities such as electricity, water, gas, or internet services.'
  },
  {
    'category': 'Transportation Expenses',
    'description':
        'Expenses related to transportation, including fuel, vehicle maintenance, and public transportation costs.'
  },
  {
    'category': 'Food and Groceries',
    'description':
        'Expenses for food, groceries, dining out, or ordering takeout.'
  },
  {
    'category': 'Health and Medical Expenses',
    'description':
        'Expenses related to healthcare, including insurance premiums, doctor visits, medications, and treatments.'
  },
  {
    'category': 'Debt Payments',
    'description':
        'Expenses for repaying debts, such as credit card payments, loans, or mortgages.'
  },
  {
    'category': 'Personal Care',
    'description':
        'Expenses for personal care items, including toiletries, cosmetics, or grooming services.'
  },
  {
    'category': 'Education Expenses',
    'description':
        'Expenses related to education, including tuition fees, textbooks, or educational materials.'
  },
  {
    'category': 'Entertainment',
    'description':
        'Expenses for entertainment activities, such as movies, concerts, or vacations.'
  },
  {
    'category': 'Clothing and Accessories',
    'description':
        'Expenses for clothing, shoes, accessories, or personal fashion items.'
  },
  {
    'category': 'Insurance Premiums',
    'description':
        'Expenses for insurance policies, such as health insurance, car insurance, or life insurance.'
  },
  {
    'category': 'Savings and Investments',
    'description':
        'Expenses allocated for savings or investments for future financial goals.'
  },
  {
    'category': 'Charitable Donations',
    'description':
        'Expenses for donations or contributions to charitable organizations.'
  },
  {
    'category': 'Travel Expenses',
    'description':
        'Expenses related to travel, including transportation, accommodation, and vacation activities.'
  },
  {
    'category': 'Home Maintenance',
    'description':
        'Expenses for maintaining or repairing your home or property.'
  },
];

List<Map<String, String>> budgetingGoals = [
  {
    'category': 'Savings',
    'description':
        'Allocate funds for emergency savings, short-term goals, and long-term goals.'
  },
  {
    'category': 'Debt Repayment',
    'description':
        'Focus on paying off high-interest debts to improve your financial health.'
  },
  {
    'category': 'Housing',
    'description':
        'Include expenses related to rent or mortgage payments, property taxes, home repairs, and maintenance.'
  },
  {
    'category': 'Transportation',
    'description':
        'Account for car payments, fuel, insurance, maintenance, and public transportation costs.'
  },
  {
    'category': 'Utilities',
    'description':
        'Cover monthly bills for electricity, water, gas, internet, and phone services.'
  },
  {
    'category': 'Food',
    'description':
        'Include groceries, dining out, and packed meals for work or school.'
  },
  {
    'category': 'Health and Wellness',
    'description':
        'Budget for health insurance premiums, medical expenses, gym memberships, and wellness activities.'
  },
  {
    'category': 'Education',
    'description':
        'Allocate funds for tuition fees, textbooks, online courses, or professional development.'
  },
  {
    'category': 'Entertainment',
    'description':
        'Set aside a portion for leisure activities, hobbies, movies, concerts, or dining out.'
  },
  {
    'category': 'Personal Care',
    'description':
        'Budget for personal grooming, haircuts, salon visits, skincare products, and clothing.'
  },
  {
    'category': 'Gifts and Celebrations',
    'description':
        'Include funds for birthdays, anniversaries, holidays, weddings, or other special occasions.'
  },
  {
    'category': 'Charitable Contributions',
    'description':
        'Allocate a portion of your budget for donations to charitable organizations or causes you support.'
  },
  {
    'category': 'Insurance',
    'description':
        'Account for life insurance, disability insurance, or any other insurance policies you may have.'
  },
  {
    'category': 'Taxes',
    'description':
        'Set aside funds for income tax, property tax, or any other taxes you are responsible for.'
  },
  {
    'category': 'Miscellaneous',
    'description':
        'Include a category for unexpected or miscellaneous expenses that may arise throughout the year.'
  },
];
