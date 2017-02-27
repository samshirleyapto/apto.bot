<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

  <script>

  $.ajax({
    url: "https://api.weatherunlocked.com/api/snowreport/{RESORT_ID}?app_id=8bba6485&app_key=da8cd345ba717c460de39fda5cc8e18d",
    type: "GET",
    success: function (parsedResponse, statusText, jqXhr) {

      console.log(parsedResponse);

    },
    error: function (error) {

      console.log(error);
    }
  });

</script>


