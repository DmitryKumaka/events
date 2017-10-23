function updateEventTable(data) {
    processed_data = processData(data);
    $('#events').bootstrapTable("load", processed_data)
}

function processData(data) {
    $.each(data, function(index, object) {
        id = object.id;
        show_link = '<a class="action-link" href="/events/'+id+'">Show</a>';
        edit_link = '<a class="action-link" href="/events/'+id+'/edit">Edit</a>';
        destroy_link = '<a class="action-link" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/events/'+id+'">Destroy</a>';
        users_link = '<a class="action-link" href="/events/'+id+'/users">Users</a>';
        object.actions = show_link + edit_link + destroy_link + users_link;
    });
    return data
}

function allEvents() {
    return gon.all_events
}

$(document).ready(function () {
    var table_column =
        [{
            field: 'id',
            title: 'Event ID'
        }, {
            field: 'name',
            title: 'Name'
        }, {
            field: 'date',
            title: 'Date'
        },{
            field: 'visited_flag',
            title: 'Visited'
        },{
            field: 'actions',
            title: 'Actions'
        }];

    $('#all-events').click(function() {
        updateEventTable(allEvents());
    });

    $('#visited-events').click(function() {
        updateEventTable(gon.visited_events);
    });

    $('#not-visited-events').click(function() {
        updateEventTable(gon.not_visited_events);
    });

    $('#past-events').click(function() {
        updateEventTable(gon.past_events);
    });

    $('#feature-events').click(function() {
        updateEventTable(gon.feature_events);
    });

    $('#events').each(function() {
        $(this).bootstrapTable({
            columns: table_column,
            data: processData(allEvents())
        });
    });
});
