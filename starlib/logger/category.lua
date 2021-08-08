

static('Category', function()
    categgories = categgories or {}

    function m:inheritFromParent(config, category, name)
        if category.inherit == false then
            return
        end
        local parentName = string.match(name, '(.*)%.')
        local parentCategory = config.categories[parentName]
        if not parentCategory then
            parentCategory = {inherit=true, appenders={}}
        end
        m:inheritFromParent(config, parentCategory, parentName)

        if not config.categories[parentName] 
            and parentCategory.appenders
            and #parentCategory.appenders > 0
            and parentCategory.level
        then
            config.categories[parentName] = parentCategory
        end

        category.appenders = category.appenders or {}
        category.level = category.level || parentCategory.level

        for _, ap in pairs(parentCategory.appenders) do
            if table.includes(category.appenders, ap) then
                table.insert(category.appenders, ap)
            end
        end

        category.parent = parentCategory
    end

    function m:getAppenders()
    end

    function m:setLevel()
    end

    function m:getLevel()
    end

    function m:setEnableStack()
    end

    function m:getEnableStack()
    end
end)