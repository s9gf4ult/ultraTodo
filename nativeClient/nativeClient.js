var options =
    [ { value: "one", label: "One" },
      { value: "two", label: "Two" }
    ]

var printChange = function(val) {
  console.log(val);
}

ReactDOM.render(<Select options={options} onChange={printChange} />, document.getElementById('todoClient'));
