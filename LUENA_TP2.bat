Skip to content
Why GitHub? 
Team
Enterprise
Explore 
Marketplace
Pricing 
Search

Sign in
Sign up
tiagodavi70
/
exemplos_mapa_d3_2021
00
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
exemplos_mapa_d3_2021/index.html
@tiagodavi70
tiagodavi70 only commit
Latest commit 372bacd 3 days ago
 History
 1 contributor
160 lines (122 sloc)  4.39 KB
  
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <script src="https://d3js.org/d3.v6.js"></script>
    <style>
    </style>
</head>

<body>


</body>

<script>
    
    function loadMap(svg, geo_data, data){
        console.log(geo_data)
        let projection = d3.geoMercator()
            .scale(80)
            .translate([width / 2, height / 2]);

        let path = d3.geoPath().projection(projection);

        svg.selectAll("path")
            .data(geo_data.features)
            .join("path")
            .attr("d", d => path(d))
            .attr("fill", "steelblue")
            .attr("stroke", "black")
            .attr("id", d=> d.properties.name)
            .attr("stroke-width", 1);

        loadCircles(svg, projection, data);
    }

    function loadMapAqua(svg, geo_data, data, svgLine){
        console.log(geo_data)
        let projection = d3.geoMercator()
            .scale(80)
            .translate([width / 2, height / 2]);

        let path = d3.geoPath().projection(projection);

        let map = svg.selectAll("path")
            .data(geo_data.features)
            .join("path")
            .attr("d", d => path(d))
            .attr("fill", "steelblue")
            .attr("stroke", "black")
            .attr("id", d=> d.properties.name)
            .attr("stroke-width", 1)
            .on("mousedown", function(e, d) {
                map.style("fill", "steelblue");
                d3.select(this).style("fill","red");
                let name = d.properties.geounit;
                let selection = data.filter(d => d["Land Area"] == name);
                
                drawLines(selection[0], svgLine)
            });

    }

    function drawLines(dataFull, svg){
        let data = [];
        
        for (let i = 2000 ; i <= 2015 ; i++) {
            data.push({"year": new Date(i,1,1), "value": +dataFull[i]})
        }
        
        let x = d3.scaleTime()
            .domain(d3.extent(data, d => d.year))
            .range([margin, width - margin])

        let y = d3.scaleLinear()
            .domain([0, d3.max(data, d => d.value)]).nice()
            .range([height - margin, margin])

        let line = d3.line()
            .defined(d => !isNaN(d.value))
            .x(d => x(d.year))
            .y(d => y(d.value))

        // console.log(data, x.domain(), x(2000), d3.extent(data, d => d.year))

        svg.selectAll("*").remove();
        svg.append("path")
            .datum(data)
            .attr("fill", "none")
            .attr("stroke", "steelblue")
            .attr("d", line);
    }

    function loadCircles(svg, projection, data) {
        
        let colorScale = d3.scaleOrdinal()
                            .domain([...new Set(data.map(d => d.fall))])
                            .range(["red", "green"])

        svg.append('g')
            .selectAll("circle")
            .data(data)
            .join("circle")
                .attr("cx", d => projection([+d.reclong, +d.reclat])[0])
                .attr("cy", d => projection([+d.reclong, +d.reclat])[1])
                .attr("r", 2)
                .style("opacity", .5)
                .style("fill", d => colorScale(d.fall)); 
    }


    let mapData = [];
    let globalMeteorite = [];
    let aquaculture = [];


    let margin = 75,
        width = 500 - margin,
        height = 500 - margin;

    Promise.all([d3.json("custom.geo.json"),
                d3.csv("meteorite-landings.csv"),
                d3.csv("Americas_Quantity.csv")]).then( results => {

        mapData = results[0];
        globalMeteorite = results[1];
        aquaculture = results[2];
        

        let svg_mapa = d3.select("body")
            .append("svg")
                .attr("width", width + margin)
                .attr("height", height + margin)
            .append('g')
                .attr('class', 'map');

        let svg_vis1 = d3.select("body")
            .append("svg")
                .attr("width", width + margin)
                .attr("height", height + margin)
            .append('g')
                .attr('class', 'map');

        let svg_vis2 = d3.select("body")
            .append("svg")
                .attr("width", width + margin)
                .attr("height", height + margin)
            .append('g')
                .attr('class', 'map');

        loadMap(svg_mapa, mapData, globalMeteorite)

        loadMapAqua(svg_vis1, mapData, aquaculture, svg_vis2)
        console.log(aquaculture)
    })

</script>

</html>
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
