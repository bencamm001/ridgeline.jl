module Ridgeline

using Pkg

    try
        using KernelDensity
        using Plots
    catch
        using Pkg
        Pkg.add("KernelDensity")
        Pkg.add("Plots")
        using KernelDensity
        using Plots
    end


    ridgeline = function(;  data = ["default"],
                            ylabels::Array = ["default"],
                            ridgecolors::Array = ["default"],
                            spacer::Float64 = 0.2,
                            riser::Float64 = 0.001,
                            plottitle::String = "Ridgydidgy Plot",
                            plotxlab::String = "name_me",
                            plotylab::String = "name_me",
                            xlabsize::Int64 = 10,
                            ylabsize::Int64 = 10,
                            titlesize::Int64 = 20,
                            hlinecolor::String = "grey",
                            hlw::Float64 = 0.4,
                            halpha::Float64 = 0.8,
                            ridgealpha::Float64 = 0.9,
                            ridgeoutline::String = "white",
                            ridgelw::Float64 = 2.0,
                            scaling::Bool = false,
                            numbers::Bool = false,
                            revnumbers::Bool = false,
                            xtext::Float64 = 0.0,
                            ytext::Float64 = 0.0,
                            annosize::Int64 = 5,
                            showplot::Bool = true
                            )

        #default or argument for data
        if data[1] == "default"
            data = [randn(100), randn(100), randn(100)]
        end

        #make array of correct size to populate
        dense = Any[]
        xs = Any[]

        #scaling to show relavtive densities
        if scaling == true
            scaling = length.(data) ./ maximum(length.(data))
        else
            scaling = ones(length(data))
        end

        #make density plot line data for plotting
        for i in 1:size(data, 1)

            temp = kde(data[i])
            push!(dense, [(temp.density .* scaling[i]) .+ ((((i - 1) * spacer) .+ riser))])
            push!(xs, [temp.x])

        end




        #find ideal x and y lims
        xlimits = Float64[]
        for i in 1:size(data, 1)
            push!(xlimits, minimum(xs[i][1]))
            push!(xlimits, maximum(xs[i][1]))
        end

        ylimits = Float64[]
        for i in 1:size(data, 1)
            push!(ylimits, minimum(dense[i][1]))
            push!(ylimits, maximum(dense[i][1]))
        end


        #default or argument colors
        if ridgecolors[1] == "default"
            ridgecolors = 1:size(data,1)
        end

        #default or argument for ylabels
        if ylabels[1] == "default"
            ylabels = fill(" A ", size(data,1))
        end

        #adjust aesthetics of plot
        h1 = Plots.plot(yticks = (collect((size(dense,1) - 1):-1:0) .* (spacer), reverse(ylabels)))
        Plots.plot!(grid = false)
        Plots.plot!(title = plottitle)
        Plots.plot!(xlab = plotxlab)
        Plots.plot!(ylab = plotylab)
        Plots.plot!(xtickfontsize = xlabsize)
        Plots.plot!(ytickfontsize = ylabsize)
        Plots.plot!(titlefontsize = titlesize)
        Plots.plot!(xlim = [minimum(xlimits), maximum(xlimits)])
        Plots.plot!(ylim = [minimum(ylimits), maximum(ylimits)])
        Plots.hline!([(collect((size(dense,1) - 1):-1:0)) .* (spacer)], color = hlinecolor, lw = hlw, label = "", alpha = halpha)

        #add annotation for n for each line
        if revnumbers == true
            anno_numbers = "n = " .* reverse(string.(length.(data)))
        else
            anno_numbers = "n = " .* string.(length.(data))
        end

        if numbers == true
            annotate!(maximum(xlimits) + xtext, (collect((size(dense,1) - 1):-1:0)) .* (spacer) .+ ytext, anno_numbers, annosize)
        end



        #plotting each curve
        for i in size(dense, 1):-1:1

            #add plots
            if showplot == true
                display(Plots.plot!(xs[i], dense[i], fillrange = ((i - 1) * spacer), label = "", fillalpha = ridgealpha,
                            linecolor = ridgeoutline, lw = ridgelw, fillcolor = ridgecolors[i]))
            else
                Plots.plot!(xs[i], dense[i], fillrange = ((i - 1) * spacer), label = "", fillalpha = ridgealpha,
                            linecolor = ridgeoutline, lw = ridgelw, fillcolor = ridgecolors[i]);
            end



        end
        return(h1)

    end
end
