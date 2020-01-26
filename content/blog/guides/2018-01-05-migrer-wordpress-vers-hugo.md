---
title: "Migrer d'un WordPress vers Hugo"
description: "Guide et scripts PHP pour migrer le contenu de son site WordPress vers un générateur de site statique tel que Hugo."
tags: [ "Wordpress", "Hugo" ]
lastmod: "2018-01-05 08:54:26"
date: "2018-01-05 08:43:46"
categories:
    - "Guides"
type: post
slug: "migrer-wordpress-vers-hugo"
cover: "/media/2018/01/f6840c5d35c17f43623f8cb9eb7d6f7e.png"
---

Ayant récement migré de WordPress vers Hugo, j'ai eu besoin d'exporter le contenu de la base de données vers des fichiers Markdown, mais aussi revoir l'organisation des ressources, notamment les images. Pour cela, j'ai implémenté quelques scripts que je me propose ici de partager.

{{< img src="/media/2018/01/f6840c5d35c17f43623f8cb9eb7d6f7e.png" >}}

<!--more-->

Depuis novembre 2013, le site **Tuto Wibb** était géré avec un WordPress. Fin 2017, j'ai décidé d'ajouter une partie blog à mon site perso et donc de fusionner **vonKrafft.fr** et **Tuto Wibb**. J'en ai profité pour abandonner WordPress, trop lourd pour mes besoins, et surtout trop compliqué à maintenir avec l'avalanche de mise à jour et de patchs de sécurité de la part de WordPress, mais aussi des plugins ...

J'ai donc porté mon intérêt sur [Hugo](https://gohugo.io/), un générateur de site statique implémenté en Golang. Le principe est simple : le contenu est rédigé en Markdown, auquel on y ajoute des templates en HTML et des ressources variées (images, CSS, JavaScript ...). Hugo se charge ensuite de générer les pages HTML. Plus de requêtes dynamiques, fini le PHP de WordPress : tout est **statique**. Cela permet aussi de versionner le contenu de **vonKrafft.fr** sur [GitHub](https://github.com/vonKrafft/vonkrafft-hugo).

Se pose alors le problème de la migration. Le contenu des articles est actuellement dans une **base de données**, les images sont dans `wp-content/uploads` et l'organisation par catégorie est géré par deux tables de la base de données ... Bref, un joli bazar !

## Exporter les articles en Markdown

La première étape consite à exporter les articles (les types `post` dans WordPress) et de créer des fichiers Markdown compréhensibles par Hugo. Le contenu des articles se trouve dans la table `wp_posts`, et nous voulons récupérer uniquement les articles de type `post` publiés.

{{< highlight PHP >}}
$wpdb->get_var("SELECT GROUP_CONCAT(`ID`) FROM `wp_posts` WHERE `post_status` LIKE 'publish' AND `post_type` LIKE 'post'");
{{< /highlight >}}

Cela permet d'obtenir la liste des ID des articles à exporter. Nous itérerons par la suite sur la liste de ces ID. Pour chaque article, il faut à présent récupérer le contenu et les informations additionnelles de la table `wp_posts`. Dans mon cas, j'ai aussi besoin de la catégorie, la liste des tags et la description SEO de l'article.

{{< highlight PHP >}}
$current_post = $wpdb->get_row($wpdb->prepare("SELECT * FROM `wp_posts` WHERE `ID` = %d", array($id)));
$current_term = $wpdb->get_results($wpdb->prepare("SELECT `name`, `slug` FROM `wp_term_taxonomy` AS tt JOIN `wp_term_relationships` AS tr ON tt.`term_taxonomy_id` = tr.`term_taxonomy_id` JOIN `wp_terms` AS t ON tt.`term_id` = t.`term_id` WHERE tr.`object_id` = %d AND tt.`taxonomy` = %s", array($id, 'category')));
$current_tags = $wpdb->get_results($wpdb->prepare("SELECT `name`, `slug` FROM `wp_term_taxonomy` AS tt JOIN `wp_term_relationships` AS tr ON tt.`term_taxonomy_id` = tr.`term_taxonomy_id` JOIN `wp_terms` AS t ON tt.`term_id` = t.`term_id` WHERE tr.`object_id` = %d AND tt.`taxonomy` = %s", array($id, 'post_tag')), OBJECT_K);
$current_desc = $wpdb->get_var($wpdb->prepare("SELECT `meta_value` FROM `wp_postmeta` WHERE `post_id` = %d AND `meta_key` = %s", array($id, '_yoast_wpseo_metadesc')));
{{< /highlight >}}

Ensuite, il faut construire le contenu du fichier. Hugo utilise un format d'en-tête spécifique pour les métadonnées de la page : les Front Matter (de l'anglais "avant-propos"). En TOML, YAML ou JSON, ils doivent être placés au début du fichier. Pour ma part, j'ai choisi le format YAML délimité par `---`.

{{< highlight PHP >}}
function get_post_content($id)
{
	global $wpdb;
	
	$current_post = $wpdb->get_row($wpdb->prepare("SELECT * FROM `wp_posts` WHERE `ID` = %d", array($id)));
	$current_term = $wpdb->get_results($wpdb->prepare("SELECT `name`, `slug` FROM `wp_term_taxonomy` AS tt JOIN `wp_term_relationships` AS tr ON tt.`term_taxonomy_id` = tr.`term_taxonomy_id` JOIN `wp_terms` AS t ON tt.`term_id` = t.`term_id` WHERE tr.`object_id` = %d AND tt.`taxonomy` = %s", array($id, 'category')));
	$current_tags = $wpdb->get_results($wpdb->prepare("SELECT `name`, `slug` FROM `wp_term_taxonomy` AS tt JOIN `wp_term_relationships` AS tr ON tt.`term_taxonomy_id` = tr.`term_taxonomy_id` JOIN `wp_terms` AS t ON tt.`term_id` = t.`term_id` WHERE tr.`object_id` = %d AND tt.`taxonomy` = %s", array($id, 'post_tag')), OBJECT_K);
	$current_desc = $wpdb->get_var($wpdb->prepare("SELECT `meta_value` FROM `wp_postmeta` WHERE `post_id` = %d AND `meta_key` = %s", array($id, '_yoast_wpseo_metadesc')));

	$markdown = '';
	$markdown .= '---' . PHP_EOL;
	$markdown .= 'title: "' . addslashes($current_post->post_title) . '"' . PHP_EOL;
	$markdown .= 'description: "' . addslashes($current_desc) . '"' . PHP_EOL;
	$markdown .= 'tags: [ "' . implode('", "', array_keys($current_tags)) . '" ]' . PHP_EOL;
	$markdown .= 'lastmod: "' . $current_post->post_modified . '"' . PHP_EOL;
	$markdown .= 'date: "' . $current_post->post_date . '"' . PHP_EOL;
	$markdown .= 'categories:' . PHP_EOL;
	foreach ($current_term as $cat) $markdown .= "\t" . '- "' . addslashes($cat->name) . '"' . PHP_EOL;
	$markdown .= 'type: page' . PHP_EOL;
	$markdown .= 'slug: "' . addslashes($current_post->post_name) . '"' . PHP_EOL;
	$markdown .= '---' . PHP_EOL;
	$markdown .= PHP_EOL;
	$markdown .= md($current_post->post_content);

	$path = $current_term[0]->slug;
	$filename = strstr($current_post->post_date, ' ', TRUE) . '-' . $current_post->post_name . '.md';

	return array($markdown, $path, $filename);
}
{{< /highlight >}}

Vous pouvez constater que je ne prends pas le contenu brut de l'article, mais je le fait passé par la fonction `md()`.

{{< highlight PHP >}}
function md($content)
{
	for ($i=1; $i < 7; $i++) { 
		$content = preg_replace("/&lt;h$i&gt;((?:.|\n)*?)&lt;\/h$i&gt;/", PHP_EOL . str_repeat('#', $i) . " $1" . PHP_EOL, $content);
	}
	$content = preg_replace('/&lt;code&gt;([^&lt;]*)&lt;\/code&gt;/', "`$1`", $content);
	$content = preg_replace('/&lt;(?:strong|b)&gt;([^&lt;]*)&lt;\/(?:strong|b)&gt;/', "**$1**", $content);
	$content = preg_replace('/&lt;(?:em|i)&gt;([^&lt;]*)&lt;\/(?:em|i)&gt;/', "*$1*", $content);
	$content = preg_replace('/&lt;blockquote&gt;((?:.|\n)*?)&lt;\/blockquote&gt;/', PHP_EOL . '&gt; ' . str_replace('\n', PHP_EOL . '&gt; ', "$1"), $content);
	$content = preg_replace('/&lt;hr( \/)?&gt;/', "---", $content);
	$content = preg_replace('/&lt;img [^&gt;]*src="([^"]*)"[^&gt;]*alt="([^"]*)"[^&gt;]*&gt;/', "![$2]($1)", $content);
	$content = preg_replace('/&lt;img [^&gt;]*alt="([^"]*)"[^&gt;]*src="([^"]*)"[^&gt;]*&gt;/', "![$1]($2)", $content);
	$content = preg_replace('/&lt;a [^&gt;]*href="([^"]+)"[^&gt;]*&gt;([^&lt;]*)&lt;\/a&gt;/', "[$2]($1)", $content);
	$content = preg_replace('/\[(tw_[^\]]*)\]/', "{{&lt; $1 &gt;}}", $content);
	$content = preg_replace('/\[(\/tw_[^\]]*)\]/', "{{&lt; $1 &gt;}}", $content);
	$content = preg_replace('/https?:\/\/tuto-wibb\.krafft\.ovh\/wp-content\/uploads\/([^\)]+)/', "images/$1", $content);
	$content = preg_replace('/&lt;p[^&gt;]*&gt;((?:.|\n)*?)&lt;\/p&gt;/', "$1" . PHP_EOL, $content);
	preg_match_all('/&lt;ul[^&gt;]*&gt;((?:.|\n)*?)&lt;\/ul&gt;/', $content, $ul_array, PREG_SET_ORDER, 0);
	foreach ($ul_array as $ul) {
		$content = str_replace($ul[0], preg_replace('/\s+&lt;li[^&gt;]*&gt;((?:.|\n)*?)&lt;\/li&gt;/', PHP_EOL . "- $1", $ul[1]), $content);
	}
	preg_match_all('/&lt;ol[^&gt;]*&gt;((?:.|\n)*?)&lt;\/ol&gt;/', $content, $ol_array, PREG_SET_ORDER, 0);
	foreach ($ol_array as $ol) {
		$content = str_replace($ol[0], preg_replace('/\s+&lt;li[^&gt;]*&gt;((?:.|\n)*?)&lt;\/li&gt;/', PHP_EOL . "1. $1", $ol[1]), $content);
	}
	return $content;
}
{{< /highlight >}}

Bon, la fonction n'est pas parfaite, loin de là, mais je n'ai pas trouvé mieux (sinon utiliser une bibliothèque PHP-Markdown pour faire le boulot). Si vous avez des idées, n'hésitez pas à me le dire : c'est trop tard pour ma migration mais ça peut en aider d'autres. Quoi qu'il en soit, je dois repasser par chaque article pour vérifier que tout est bien passé en Markdown.

Après quelques tests, il ne nous reste plus qu'à automatiser le tout et créer les fichiers de sortie. Une boucle sur la liste des ID des articles, et le tour est joué :)

{{< highlight PHP >}}
$posts = $wpdb->get_var("SELECT GROUP_CONCAT(`ID`) FROM `wp_posts` WHERE `post_status` LIKE 'publish' AND `post_type` LIKE 'post'");
foreach ($posts as $id) {
	list($content, $category, $filename) = get_content($id);
	mkdir('hugo/' . $category, 0755, TRUE);
	file_put_contents('hugo/' . $category . '/' . $filename, $content);
}
{{< /highlight >}}

Et voilà, on se retrouve avec nos fichiers Markdown ! Il suffit de tout mettre dans le répertoire `content` de Hugo et c'est terminé.

## Exporter les pages en Markdown

C'est presque identique à l'exportation des articles. L'en-tête du fichier change légèrement : on n'a plus de description, de tags, de catégorie et de slug, et le type n'est plus `post` mais `page`. Pour ce qui est du chemin du fichier Markdown, il y a deux cas possibles :

- La page n'a pas de page parente, dans ce cas là elle est enregistrée dans `/nom-de-la-page/_index.md` ;
- La page a une page parente, dans ce cas là elle est enregistrée dans `/nom-du-parent/nom-de-la-page.md`.

{{< highlight PHP >}}
function get_page_content($id)
{
	global $wpdb;
	
	$current_page = $wpdb->get_row($wpdb->prepare("SELECT * FROM `wp_posts` WHERE `ID` = %d", array($id)));

	if (intval($current_page->post_parent) > 0)
	{
		$current_parent = $wpdb->get_row($wpdb->prepare("SELECT * FROM `wp_posts` WHERE `ID` = %d", array(intval($current_page->post_parent))));
	}

	$markdown = '';
	$markdown .= '---' . PHP_EOL;
	$markdown .= 'title: "' . (isset($current_parent) ? addslashes($current_parent->post_title) .  ' | ' : '') . addslashes($current_page->post_title) . '"' . PHP_EOL;
	$markdown .= 'lastmod: "' . $current_page->post_modified . '"' . PHP_EOL;
	$markdown .= 'date: "' . $current_page->post_date . '"' . PHP_EOL;
	$markdown .= 'type: page' . PHP_EOL;
	$markdown .= '---' . PHP_EOL;
	$markdown .= PHP_EOL;
	$markdown .= md($current_page->post_content);

	$path = isset($current_parent) ? $current_parent->post_name : $current_page->post_name;
	$filename = isset($current_parent) ? $current_page->post_name . '.md' : '_index.md';

	return array($markdown, $path, $filename);
}
{{< /highlight >}}

Pour créer tous mes fichiers, il me suffit alors de boucler sur la liste des ID des pages.

{{< highlight PHP >}}
$pages = explode(',', $wpdb->get_var("SELECT GROUP_CONCAT(`ID`) FROM `wp_posts` WHERE `post_status` LIKE 'publish' AND `post_type` LIKE 'page'"));
foreach ($pages as $id) {
	list($content, $path, $filename) = get_page_content($id);
	mkdir('hugo/pages/' . $path, 0755, TRUE);
	file_put_contents('hugo/pages/' . $path . '/' . $filename, $content);
}
{{< /highlight >}}

## Vérfier le contenu et importer les images

Je vais vous l'avouer tout de suite, c'est la partie casse-coui****s de la migration. La vérification est optionnelle, il est possible de se satisfaire de la correction des erreurs remontées par Hugo. Quant aux images, un copié/collé de `wp-content/uploads` et le tour est joué. Mais je ne trouve pas ça très propre et quitte à migrer, autant faire les choses bien.

Pour les images, j'ai créé un répertoire `static/media` dans lequel je mets toutes mes images triée par années et par mois. Pour un article de décembre 2017, mes images seront dans `static/media/2017/12`. Pour les pages, je crée un répertoire par page ou groupe de pages.

Ensuite, j'ai parcouru tous les articles pour vérifier la syntaxe du Markdown, ajouter des shortcodes et inclure les images. Puisque par la suite, je vais avoir besoin d'ajouter des images aux futurs articles, je me suis dit qu'il me fallait quelque chose pour redimensionner mes images. J'ai donc implémenté un petit script qui [copie et redimensionne une image](/console/redimensionner-images-python/).

## Rediriger son ancien site WordPress vers Hugo

{{< alert "info" info-circle >}}Si vous ne changez pas de nom de domaine, vous pouvez ignorer cette dernière partie. Pour ma part, je suis passé de http://tuto-wibb.krafft.ovh/ à https://vonkrafft.fr/, et donc j'avais besoin de mettre en place une redirection.{{< /alert >}}

Voilà, un joli site statique avec Hugo, tout beau tout neuf, mais que faire de l'ancien site ? Il faut surtout éviter de le supprimer, ou en tout cas pas tout de suite. Aussi longtemps que possible, il faut mettre en place une redirection permanente vers vos nouveaux articles.

Pour cela, on va créer un fichier `index.php` à la racine du WordPress (sans oublié de faire une copie de l'ancien fichier vers un fichier `index.php.initial` par exemple).

{{< highlight PHP >}}
&lt;?php    
require_once(dirname(__FILE__) . '/wp-load.php');
global $wpdb;

$actual_link = (isset($_SERVER['HTTPS']) ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
$id = url_to_postid($actual_link);

$type = $wpdb->get_var($wpdb->prepare('SELECT `post_type` FROM `wp_posts` WHERE `ID` = %d', $id));
if ($type === 'page')
{
	$parent_id = $wpdb->get_var($wpdb->prepare('SELECT `post_parent` FROM `wp_posts` WHERE `ID` = %d', $id));
	$path = $parent_id ? $wpdb->get_var($wpdb->prepare('SELECT `post_name` FROM `wp_posts` WHERE `ID` = %d', $parent_id)) . '/' : '';
}
else
{
	$path = strtolower($wpdb->get_var($wpdb->prepare('SELECT `name` FROM `wp_term_taxonomy` AS tt JOIN `wp_term_relationships` AS tr ON tt.`term_taxonomy_id` = tr.`term_taxonomy_id` JOIN `wp_terms` AS t ON tt.`term_id` = t.`term_id` WHERE tr.`object_id` = %d AND tt.`taxonomy` = %s', array($id, 'category')))) . '/';
}
$slug = $wpdb->get_var($wpdb->prepare('SELECT `post_name` FROM `wp_posts` WHERE `ID` = %d', $id));

$new_link = "https://vonkrafft.fr/$path$slug/";

header('Status: 301 Moved Permanently', False, 301);      
header('Location: ' . $new_link);      
exit();
{{< /highlight >}}

Bon, ça casse pas trois pattes à un canard. Tout d'abord, on récupère l'URL et l'ID associé à l'URL. Si c'est une page, la nouvelle URL débutera par le slug de la page parente, si page parente il y a. Si c'est un article, la nouvelle URL débutera par le slug de la catégorie. Enfin, on récupère le slug du post pour terminer la nouvelle URL.

La redirection doit être permanente, avec le code HTTP 301 (Moved Permanently). Cela permet de faire comprendre aux navigateurs et aux robots que le site est définitivement à cette nouvelle adresse.

Le fichier `index.php` doit être conservé le plus longtemps possible (cela nécessite un serveur et un nom de domaine). Lorsque le serveur ne sera plus disponible, il faudra ajouter une entrée DNS `CNAME` de votre ancien nom de domaine vers votre nouveau nom de domaine. Et lorsque votre ancien nom de domaine ne sera plus disponible, et bien tant pis ...

## Conclusion

On a donc des fonctions PHP pour :

- Convertir le contenu d'un post WordPress en Markdown (je reste ouvert aux suggestions d'amélioration) ;
- Générer un export d'un article (type `post`) ;
- Générer un export d'une page (type `page`) ;
- Mettre en place une rediretcion dans le cas d'un changement de domaine.

En mixant tout ça, vous pouvez à présent migrer votre site WordPress vers Hugo. Tout n'est pas automatisé, une longue phase de vérification est nécessaire pour chaque fichier Markdown, surtout si comme moi vous choisissez de revoir toutes vos illustrations.

En espérant en aider (et en motiver) certains à migrer vers un site statique :)
