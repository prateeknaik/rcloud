((function() {
    var info_popover_ = null; // current opened information popover

    function remove_all_popovers() {
        // nicer methods don't work,
        // because the parent gets recreated every time the notebook
        // tree refreshes
        $('div.popover.notebook-info').remove();
    }

    //for hiding information popover on click outside
    $('body').on('click', function(e) {
        if($(e.target).data('toggle') !== 'popover' &&
           $(e.target).parents('.popover.in').length === 0) {
            remove_all_popovers();
        }
    });
    return {
        init: function(k) {
            RCloud.UI.notebook_commands.add({
                notebook_info: {
                    section: 'appear',
                    sort: 1000,
                    create: function(node) {
                        var info = ui_utils.fa_button('icon-info-sign', 'notebook info', 'info',
                                                      RCloud.UI.notebook_commands.icon_style(), false);
                        info.click(function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var thisIcon = this;
                            var info_content = '';
                            if(info_popover_) {
                                info_popover_.popover('destroy');
                                info_popover_ = null;
                            }


                            Promise.all( [rcloud.protection.get_notebook_cryptgroup(node.gistname), 
                                        rcloud.stars.get_notebook_starrer_list(node.gistname)])
                            .spread(function(cryptogroup, list) {

                                if(typeof(list) === 'string')
                                    list = [list];

                                var group_message;
                                if(!cryptogroup[0] && !cryptogroup[1]){
                                    group_message = '<div class="group-link">no group</div>'
                                }
                                else{
                                    group_message = '<div class="group-link">'+cryptogroup[1]+'</div>'
                                }
 
                                    

                                var starrer_list = '<div class="info-category"><b>Starred by:</b></div>';
                                list.forEach(function (v) {
                                    starrer_list = starrer_list + '<div class="info-item">' + v + '</div>';
                                });
                                info_content = group_message + info_content + starrer_list;
                                $(thisIcon).popover({
                                    title: node.name,
                                    html: true,
                                    content: info_content,
                                    container: 'body',
                                    placement: 'right',
                                    animate: false,
                                    delay: {hide: 0}
                                });
                                $(thisIcon).popover('show');
                                var thisPopover = $(thisIcon).popover().data()['bs.popover'].$tip[0];
                                $(thisPopover).addClass('popover-offset notebook-info');
                                info_popover_ = $(thisIcon);




                                $('.group-link').click(function(){

                                    //set 
                                    RCloud.UI.notebook_protection.notebookFullName = node.full_name;
                                    RCloud.UI.notebook_protection.notebookGistName = node.gistname;
                                    RCloud.UI.notebook_protection.notebookId = node.id;

                                    //groups

                                    if(!cryptogroup[0] && !cryptogroup[1]){
                                        RCloud.UI.notebook_protection.belongsToGroup = false;
                                        console.log('does not belong');
                                    }
                                    else{
                                        RCloud.UI.notebook_protection.belongsToGroup = true
                                        RCloud.UI.notebook_protection.currentGroupName = cryptogroup[1];
                                        console.log('does belong');
                                    }

                                    //show modal
                                    RCloud.UI.notebook_protection.initWithData(node);
                                    //RCloud.UI.notebook_protection.showOverlay();

                            
                                });

                            });
                        });
                        return info;
                    }
                }
            });
            k();
        }
    };
})()) /*jshint -W033 */ // no semi; this is an expression not a statement
