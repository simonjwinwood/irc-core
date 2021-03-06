module HaskellHighlighter (highlightHaskell) where

import Language.Haskell.Lexer

highlightHaskell :: String -> String
highlightHaskell src = init (colorize (lexerPass0 (src++"\n")))
-- the lexer requires this newline for single-line comments to work

colorize :: [PosToken] -> String
colorize [] = ""
colorize ((_,(_,"`")):(Varid,(_,str)):(_,(_,"`")):rest)
  = orange ("`" ++ str ++ "`") ++ colorize rest
colorize ((tok, (_,str)):rest) = aux str ++ colorize rest
  where
  aux =
    case tok of
      Varid              -> id
      Conid              -> id
      Varsym             -> orange
      Consym             -> orange
      Reservedid ->
        case str of
          "case"         -> orange
          "of"           -> orange
          "do"           -> orange
          "if"           -> orange
          "then"         -> orange
          "else"         -> orange
          "let"          -> orange
          "in"           -> orange

          "import"       -> pink
          "infixl"       -> pink
          "infixr"       -> pink
          "infix"        -> pink

          "_"            -> id
          _              -> green

      Reservedop         -> orange
      Specialid          -> id
      IntLit             -> red
      FloatLit           -> red
      CharLit            -> red
      StringLit          -> red
      Qvarid             -> id
      Qconid             -> id
      Qvarsym            -> orange
      Qconsym            -> orange
      Special            -> id
      Whitespace         -> id
      NestedCommentStart -> comment
      NestedComment      -> comment
      LiterateComment    -> comment
      Commentstart       -> comment
      Comment            -> comment
      ErrorToken         -> id
      GotEOF             -> id
      ModuleName         -> id
      ModuleAlias        -> id
      Layout             -> id
      Indent _           -> id
      Open _             -> id
      TheRest            -> id

comment :: String -> String
comment = cyan

green, orange, red, cyan, pink :: String -> String
green  x = "\03\&03" ++ x ++ "\03\02\02"
orange x = "\03\&07" ++ x ++ "\03\02\02"
red    x = "\03\&04" ++ x ++ "\03\02\02"
cyan   x = "\03\&11" ++ x ++ "\03\02\02"
pink   x = "\03\&13" ++ x ++ "\03\02\02"
