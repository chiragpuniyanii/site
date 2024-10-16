{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" name="manage_products_form" id="manage_products_form">
        <input type="hidden" name="redirect_url" value="{$config.current_url}" />

        {include
            file="common/pagination.tpl"
            save_current_page=true
            save_current_url=false
            div_id=$smarty.request.content_id
        }

        {$c_url = $config.current_url|fn_query_remove:"sort_by":"sort_order"}

        {$rev = $smarty.request.content_id|default:"pagination_contents,content_top_navigation"}
        {$image_width = $settings.Thumbnails.product_admin_mini_icon_width}
        {include_ext file="common/icon.tpl" class="icon-`$search.sort_order_rev`" assign=c_icon}
        {include_ext file="common/icon.tpl" class="icon-dummy" assign=c_dummy}
        {if $products}
            {capture name="products_table"}
                <div class="table-responsive-wrapper longtap-selection">
                    <table width="100%" class="table table-middle table--relative table-responsive table--show-checkbox products-table">
                        <thead data-ca-bulkedit-default-object="true" data-target=".products-table" data-ca-bulkedit-component="defaultObject">
                        <tr>
                            {hook name="master_products:manage_head"}
                                <th width="3%" class="left mobile-hide table__check-items-column table__check-items-column--show-checkbox">
                                    {include file="common/check_items.tpl"
                                        show_checkbox=true
                                        is_check_disabled=!$has_select_permission
                                        meta="table__check-items table__check-items--show-checkbox"
                                        class="check-items--show-checkbox"
                                    }
                                    <input type="checkbox"
                                        class="bulkedit-toggler hide"
                                        data-ca-bulkedit-disable="[data-ca-bulkedit-default-object=true]"
                                        data-ca-bulkedit-enable="[data-ca-bulkedit-expanded-object=true]"
                                    />
                                </th>
                                <th class="table__column-without-title"></th>
                                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=product&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("name")}{if $search.sort_by === "product"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a> /&nbsp;&nbsp;&nbsp; <a class="{$ajax_class}" href="{"`$c_url`&sort_by=code&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("sku")}{if $search.sort_by === "code"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                <th width="13%"><a class="cm-ajax" href="{"`$c_url`&sort_by=price&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("price")} ({$currencies.$primary_currency.symbol nofilter}){if $search.sort_by === "price"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                                <th width="12%" class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=list_price&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("list_price")} ({$currencies.$primary_currency.symbol nofilter}){if $search.sort_by === "list_price"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                            {/hook}
                            <th width="9%" class="mobile-hide">&nbsp;</th>
                        </tr>
                        </thead>
                        <tbody>
                        {foreach $products as $product}

                            <tr class="cm-row-status-{$product.status|lower} cm-longtap-target"
                                data-ca-longtap-action="setCheckBox"
                                data-ca-longtap-target="input.cm-item"
                                data-ca-id="{$product.product_id}"
                            >

                                {hook name="master_products:manage_body"}

                                    <td width="3%" class="left mobile-hide table__check-items-cell table__check-items-cell--show-checkbox">
                                        <input type="checkbox"
                                            name="{if $runtime.company_id}master_{/if}product_ids[]"
                                            value="{$product.product_id}"
                                            class="cm-item cm-item-status-{$product.status|lower}"
                                        />
                                    </td>
                                    <td class="products-list__image">
                                        {include
                                            file="common/image.tpl"
                                            image=$product.main_pair.icon|default:$product.main_pair.detailed
                                            image_id=$product.main_pair.image_id
                                            image_width=$settings.Thumbnails.product_admin_mini_icon_width
                                            image_height=$settings.Thumbnails.product_admin_mini_icon_height
                                            href="products.update?product_id=`$product.product_id`"|fn_url
                                            image_css_class="products-list__image--img"
                                            link_css_class="products-list__image--link"
                                        }
                                    </td>
                                    <td class="product-name-column" data-th="{__("name")}">
                                        {if $product.vendor_product_id}
                                            <a class="row-status link--monochrome"
                                            href="{"products.update?product_id=`$product.vendor_product_id`"|fn_url}"
                                            >{$product.product nofilter}</a>
                                        {else}
                                            <a class="row-status link--monochrome"
                                            href="{"products.update?product_id=`$product.product_id`"|fn_url}"
                                            >{$product.product nofilter}</a>
                                        {/if}

                                        <div class="product-list__labels muted">
                                            {hook name="products:product_additional_info"}
                                                {hook name="products:list_product_code"}
                                                    <div class="product-code">
                                                        <span class="product-code__label">{$product.product_code}</span>
                                                    </div>
                                                {/hook}
                                            {/hook}
                                        </div>
                                    </td>
                                    <td width="13%" data-th="{__("price")}">
                                        {if $product.vendor_product.price}
                                            {$product.vendor_product.price|fn_format_price:$primary_currency:null:false}
                                        {else}
                                            {$product.price|fn_format_price:$primary_currency:null:false}
                                        {/if}
                                    </td>
                                    <td width="12%" data-th="{__("list_price")}">
                                        {$product.list_price|fn_format_price:$primary_currency:null:false}
                                    </td>
                                {/hook}
                                <td width="9%" class="nowrap">
                                    {if $product.vendor_product_id}
                                        <span class="pull-right label label-info">{__("master_products.for_sale")}</span>
                                    {else}
                                        {include
                                            file="buttons/button.tpl"
                                            but_text=__("master_products.sell_this")
                                            but_meta="cm-post"
                                            but_role="action"
                                            but_href="products.sell_master_product?master_product_id=`$product.product_id`"
                                        }
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                        </tbody>
                    </table>
                </div>
            {/capture}

            {include file="common/context_menu_wrapper.tpl"
                form="manage_products_form"
                object="products"
                items=$smarty.capture.products_table
            }
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {capture name="buttons"}
            {capture name="tools_list"}
                {hook name="master_products:action_buttons"}
                {/hook}
            {/capture}
            {dropdown content=$smarty.capture.tools_list}

        {/capture}

        {capture name="adv_buttons"}
            {hook name="master_products:manage_tools"}{/hook}
        {/capture}

        <div class="clearfix">
            {include file="common/pagination.tpl" div_id=$smarty.request.content_id}
        </div>

    </form>

{/capture}

{$search_form_dispatch = $dispatch|default:"products.master_products"}
{$saved_search = [
    dispatch => $search_form_dispatch,
    view_type => "products"
]}

{* Get advanced search *}
{include file="views/products/components/products_search_form.tpl"
    search=$search
    dispatch=$search_form_dispatch
    type="search_filters"
    autofocus=false
    form_meta="search-filters-advanced-search__form"
    show_search_button=false
    advanced_search_button_class="btn"
    show_advanced_search_button_icon=true
    show_advanced_search_button_text=false
    assign="products_advanced_search"
}

{* Get $search_filters, and $context_search *}
{include file="views/products/components/search_filters/get_product_search_filters.tpl"
    search=$search
    dispatch=$search_form_dispatch
    form_id="`$product_search_form_prefix`search_filters_form"
    type="search_filters"
    advanced_search=$products_advanced_search
}

{capture name="sidebar"}
    {hook name="master_products:manage_sidebar"}
    {/hook}
{/capture}

{include
    file="common/mainbox.tpl"
    title=__("master_products.products_that_vendors_can_sell")
    content=$smarty.capture.mainbox
    title_extra=$smarty.capture.title_extra
    adv_buttons=$smarty.capture.adv_buttons
    select_languages=true
    buttons=$smarty.capture.buttons
    sidebar=$smarty.capture.sidebar
    content_id="manage_products"
    saved_search=$saved_search
    search_filters=$search_filters
    context_search=$context_search
}
