/**
 *  Height of the text, in pixels.
 *  @author Alaric Cole
 *  @default 11 
 */
[Style(name="fontSize", type="Number", format="Length", inherit="yes")]
/**
 *  Whether the text is italic or not.
 *  Possible values are <code>"normal"</code> and <code>"italic"</code>.
 * 
 *  @default "normal"
 */
 [Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]
 
 /**
 *  Whether the text is bold or not.
 *  Possibl values are <code>"normal"</code> and <code>"bold"</code>.
 * 
 *  @default "normal"
 */
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]
/**
 *  Name of the font to use for the label.
 *  @default "_sans"
 */
[Style(name="fontFamily", type="String", inherit="yes")]
/**
 *  Whether the text is underlined or not.
 *  Possible values are <code>"none"</code> and <code>"underline"</code>.
 * 
 *  @default "none"
 */
[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]
/**
 *  Color of text.
 *
 */
[Style(name="color", type="uint", format="Color", inherit="yes")]
