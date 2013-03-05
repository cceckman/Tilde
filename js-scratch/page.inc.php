<?php

class Page{
    public static $nextID = 1;
    public $ID = -1;
    public $post_author = 'Charles Eckman';
    public $post_date;
    public $post_date_gmt;
    public $post_content = "Void page";
    public $post_title = "Void page";
    public $post_excerpt = "Void";
    public $post_status = 'public';
    public $comment_status = 'closed';
    public $ping_status = 'open';
    public $post_password = NULL;
    public $post_name = "nothing";
    public $to_ping;
    public $pinged;
    public $post_modified;
    public $post_modified_gmt;
    public $post_content_filtered;
    public $post_parent = 0;
    public $guid = "http://cceckan.com";
    public $menu_order;
    public $post_type = 'page';
    public $post_mime_type;
    public $comment_count;
    public $filter;

    public function __construct($title, $parent)
    {
        $this->post_title = $title;
        $this->post_parent = $parent;
        $this->ID = Page::$nextID;
        Page::$nextID = Page::$nextID + 1;
        
        $this->guid = "http://cceckman.com/js-scratch/?pageid=" . $this->ID;
    }
};

?>
