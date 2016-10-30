var getOptions = function(input, callback) {
    setTimeout(function() {
        callback(null, {
            options: [
                { value: 'one', label: 'One' },
                { value: 'two', label: 'Two' }
            ],
            // CAREFUL! Only set this to true when there are no more options,
            // or more specific queries will not be sent to the server.
            complete: true
        });
    }, 500);
};

// ReactDOM.render(<Select.Async name="form-field-name" loadOptions={getOptions} />, document.getElementById('todoClient'));
ReactDOM.render(
  React.createElement(
    eval("window['Select']['Async']")
    , { loadOptions: getOptions }
    // , null
  )
  , document.getElementById('todoClient')
);
