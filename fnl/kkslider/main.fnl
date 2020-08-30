(module kkslider.main
  {require {a kkslider.aniseed.core
            str kkslider.aniseed.string
            nvim kkslider.aniseed.nvim}})

(defonce state
  {:current nil
   :slides []})

(defn echoerr [...]
  (nvim.err_write (.. (str.join " " ["KKSlider:" ...]) "\n")))

(defn upsert-buf []
  (nvim.ex.edit_ (.. "/tmp/kkslider-" (nvim.fn.getpid) ".adoc"))
  (nvim.ex.setlocal "buftype=nofile")
  (nvim.ex.setlocal "bufhidden=hide")
  (nvim.ex.setlocal "noswapfile")
  (nvim.ex.setlocal "nobuflisted")
  (nvim.buf_set_keymap 0 :n "<left>" ":lua require('kkslider.main')['prev-slide']()<cr>" {})
  (nvim.buf_set_keymap 0 :n "<right>" ":lua require('kkslider.main')['next-slide']()<cr>" {})
  (nvim.win_get_buf 0))

(defn display [lines]
  (nvim.buf_set_lines (upsert-buf) 0 -1 false lines))

(defn parse-slides [src]
  (var current nil)
  (var acc [])
  (a.run!
    (fn [line]
      (if (line:find "^= ")
        (do
          (when current
            (table.insert acc current))
          (set current [line]))
        (table.insert current line)))
    (str.split src "\n"))
  (table.insert acc current)
  acc)

(defn update-slide [f]
  (if (not state.current)
    (a.assoc state :current 1)
    (a.update state :current f))

  (let [n state.current
        min 1
        max (a.count state.slides)]
    (if
      (> n max)
      (a.assoc state :current max)
      (< n min)
      (a.assoc state :current min)))

  (-?> (a.get-in state [:slides state.current])
       (display)))

(defn next-slide []
  (update-slide a.inc))

(defn prev-slide []
  (update-slide a.dec))

(defn open-slides [file]
  (let [src (a.slurp file)]
    (if src
      (do
        (a.assoc state :slides (parse-slides src))
        (next-slide))
      (echoerr "Couldn't load" file))))

(defn init []
  (nvim.ex.command_
    :-nargs=1 :-complete=file :KKSlider :lua
    "require('kkslider.main')['open-slides'](<q-args>)"))
