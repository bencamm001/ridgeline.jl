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


    ridgeline = function(;  data::Array = ["default"],
                            ylabels::Array = ["default"],
                            colors::Array = ["default"],
                            spacer::Float64 = 0.2,
                            riser::Float64 = 0.001,
                            plottitle::String = "Ridgydidgy Plot",
                            plotxlab::String = "name_me",
                            xlabsize::Int64 = 10,
                            ylabsize::Int64 = 10,
                            titlesize::Int64 = 20,
                            hlinecolor::String = "grey",
                            hlw::Float64 = 0.4,
                            halpha::Float64 = 0.8,
                            ridgealpha::Float64 = 0.9,
                            ridgeoutline::String = "white",
                            ridgelw::Float64 = 2.0
                            )

        #default or argument for data
        if data[1] == "default"
            data = randn(100, 3)
        end

        #make array of correct size to populate
        dense = rand(length(kde(data[:,1]).density) , size(data,2))

        for i in 1:size(data, 2)

            #make density plot line data for plotting
            dense[:,i] .= kde(data[:,i]).density .+ ((((i - 1) * spacer) .+ riser))

        end

        #find ideal x and y lims
        xlimits = Float64[]
        for i in 1:size(data, 2)
            push!(xlimits, minimum(kde(data[:,i]).x))
            push!(xlimits, maximum(kde(data[:,i]).x))
        end

        #default or argument colors
        if colors[1] == "default"
            colors = 1:size(data,2)
        end

        #default or argument for ylabels
        if ylabels[1] == "default"
            ylabels = fill(" A ", size(data,2))
        end

        #adjust aesthetics of plot
        h1 = Plots.plot(yticks = (collect((size(dense,2) - 1):-1:0) .* (spacer), ylabels))
        Plots.plot!(grid = false)
        Plots.plot!(title = plottitle)
        Plots.plot!(xlab = plotxlab)
        Plots.plot!(xtickfontsize = xlabsize)
        Plots.plot!(ytickfontsize = ylabsize)
        Plots.plot!(titlefontsize = titlesize)
        Plots.plot!(xlim = [minimum(xlimits), maximum(xlimits)])
        Plots.plot!(ylim = [minimum(dense), maximum(dense)])
        Plots.hline!([collect((size(dense,2) - 1):-1:0) .* (spacer)], color = hlinecolor, lw = hlw, label = "", alpha = halpha)

        #plotting each curve
        for i in size(dense, 2):-1:1

            #add plots
            display(Plots.plot!(kde(data[:,i]).x, dense[:,i], fillrange = ((i - 1) * spacer), label = "", fillalpha = ridgealpha,
                        linecolor = ridgeoutline, lw = ridgelw, fillcolor = colors[i]))

        end
        return(h1)

    end
end
