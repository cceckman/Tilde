<?php
/*
 * sitemap.php
 * (JS test; prospective CCE3)
 * Accepts:
 * $_GET['pageid'] as the current page
 * 
 * Returns:
 * IF included,
 *  a PHP array of Page objects (http://codex.wordpress.org/Function_Reference/get_pages)
 * IF requested,
 *  a JSON representation of the Page objects to be included in the tree
 * 
 * The set of pages to be included includes all of the children of $_GET['pageid'],
 *  the page with $_GET['pageid'] as its ID, and the path to the root.
 */

// Define site map tree;
// We make the data mirror WP in our tests.

$is_requested = sizeof(get_included_files()) == 1;

if( $is_requested )
{
    // Do WP includes to get us access
}

// Match included versions
global $page_ancestors;
global $page_children;
global $_GET;



if( !isset( $_GET['pageid'] )  || $_GET['pageid'] < 0)
{
    // Get the "home" page ID by default
    $_GET['pageid'] = 1;
    //$_GET['pageid'] = get_page_by_title("Home")->ID;
}

//*/
// Test data
include("page.inc.php");
$allpages = 
    array( new Page("Home", 0), 
        new Page("Computing", 1), 
            new Page("Code", 2), new Page("Papers", 2),
        new Page("About", 1),
        new Page("Contact", 5), new Page("Resume", 5)
    );

function get_ancestors($id, $nothing)
{
//    echo "id: " . $id . "\n";
    global $allpages;
    if(sizeof($allpages) > 1){
        $zed = sizeof($allpages);
//        echo "zed: ";
//        var_dump($zed);
    }
    $ancestors = array();
//    var_dump($allpages[$id - 1]);
    $id = $allpages[$id - 1]->post_parent;
    $in = 0;
    while($id > 0)
    {
//        echo "num: " . $in . " ";
        array_unshift($ancestors, $allpages[$id - 1]);
        $id = $ancestors[0]->post_parent;
    }
    return $ancestors;
}

function get_pages($options)
{
    global $allpages;
    $id = $options["parent"];
    $children = array();
    foreach($allpages as $pg)
    {
        if($pg->post_parent == $id)
        {
            array_push($children, $pg);
        }
    }
    return $children;
}
//*/

//*/

// function to generate output

function display_pagechain($id)
{
    // todo wp code, untested

    // todo hack in/around pages displaying as children
    global $page_ancestors, $page_children, $allpages;
    
    $page_ancestors = get_ancestors($id, 'page');
//
//    echo "ancestors:";
//    var_dump($page_ancestors);
//    
    $page_children = get_pages(array(
        'child_of' => $id,
        'parent' => $id,    // retrieve immediate children only
        'hierarchical' => 0,
        'post_status' => 'publish'
    ));

//    echo "Children:";
//    var_dump($page_children);
?>
    <div class="sitemap">
<?php

    foreach($page_ancestors as $pg)
    {
?>
    <h2 class="parent_page_link">
        <a href="<?php echo $pg->guid; ?>"><?php echo $pg->post_title; ?></a>
    </h2>
<?php
    }
    $mm = $id - 1;
//    var_dump($mm);
    $pg = $allpages[$mm];
?>
    <h2 class="current_page_link">
        <a href="<?php echo $pg->guid; ?>"><?php echo $pg->post_title; ?></a>
    </h2>

    <div class="sitemap-children">
<?php 
    foreach( $page_children as $pg )
    {
?>
        <h3 class="child_page_link">
            <a href="<?php echo $pg->guid; ?>"><?php echo $pg->post_title; ?></a>
        </h3>
<?php
    }
?>

    </div><!-- sitemap-children -->
</div><!-- sitemap -->
<?php
}

//var_dump($allpages);
//var_dump($_GET);

display_pagechain($_GET['pageid']);

?>
