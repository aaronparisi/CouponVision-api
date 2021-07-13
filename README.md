This project is a sample of data visualizations using D3 and React.

Attributions:

Murat Kemalder's [Using React (Hooks) with D3](https://dev.to/muratkemaldar/video-using-react-hooks-with-d3-the-basics-519k) series
Steve Hall's [React Compact Slider](https://codesandbox.io/s/rw97j317p)
data.world's [Grocery Store Data](https://data.world/usda/grocery-stores)

.....................................................
My Notes:

- models
  - brands
  - products
    => products no longer have categories, but they do have brands
  - grocers
  - grocer_brands
    => grocers' coupons will only come from a subset of brands
    => add validations for that on coupon creation
  - stores
  - coupons
    => coupons belong to a store and to a product

/////////////////////////////////////////////////////

- seeds
  - these seeds were designed with the "active coupons over time"
    and the "coupon counts per brand" visualizations in mind
  => active coupons over time:
    - grocers have a range of dates in which coupons can be activated,
      and a maximum number of days for which they can be active,
      (ideally resulting in varying 'peaks')
    - grocers have a maximum number of coupons they can possibly have via their stores,
      (resulting in lines of differing maximum heights)
  => coupon counts per brand
    - grocers having max number of coupons => different sizes of bars
    - grocers have a max number of brands represented
      (bars with different numbers of colors in them)

  => ideas for other aggregations:
  - US state map where color intensity represents amount of money
    to be saved at a moment in time, or lost due to expiration,
    * include date slider
    * allow to toggle between saved & lost value, filter by grocers
      or brands

/////////////////////////////////////////////////////

- routes
  => one route per data visualization

/////////////////////////////////////////////////////

- grocers controller
  => grocer model coupon_counts_by_brand
    the goal here is to return a set of data consisting of arrays of objects
    - each object represents a grocer
      its key-value pairs will consist of:
      1. the grocer name
      2. the coupon counts for each brand_id in the database
    e.g.
    [
     { 1: 5, 2: 0, ..., grocer_name: "Albertson's" }, 
     { 1: 1, 2: 2, ..., grocer_name: "QFC" }, 
     .
     .
     .
    ]
    - we need the data formatted in this way because of how we construct
      "layers" in D3 - where a layer corresponds to all same-colored "bars"
      for any particular brand.
    => when constructing the layers,
       D3 will look through the grocers and grab all the values for each brand_id
    e.g.
    a layer for brand # 1 with a green bar "5 wide" and a green bar "1 wide", and 
    a layer for brand # 2 with a red   bar "0 wide" and a red   bar "2 wide"

    => I spent a lot of time figuring out how to construct a custom
       sql query for coupon counts by brand because I:
       1. made the mistake of thiking ALL brands must be represented
          as a key in a grocer object even if that grocer
          had 0 coupons in said brand, and
       2. I didn't know how to use .pluck() effectively with .joins()
    
    => I don't think it's necessary to use .includes() here
       since I just grab all the column names I need
       and don't do any additional querying 

  => grocer model active_over_time

  TODO
  each one of these queries is "flattened" in a ~similar~ way
  I could spend some time abstracting / improving that

/////////////////////////////////////////////////////

- brands controller
......................................................

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app), using the [Redux](https://redux.js.org/) and [Redux Toolkit](https://redux-toolkit.js.org/) template.

## Available Scripts

In the project directory, you can run:

### `yarn start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `yarn test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `yarn build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `yarn eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).
